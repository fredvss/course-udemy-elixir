# Game of Stones — Fault Tolerance com Supervisor

Evolução do projeto `06-mix-tool/game_of_stones` com adição de uma **árvore de supervisão**. O objetivo é demonstrar como o OTP garante que processos com falha sejam reiniciados automaticamente.

## O que mudou em relação ao `06-mix-tool`

| | `06-mix-tool` | `07-fault-tolerance` |
|---|---|---|
| Iniciar o Server | `GenServer.start/3` | `GenServer.start_link/3` |
| Responsável pelo Server | chamador manual | Supervisor |
| Entry point | escript (`main/1`) | `iex -S mix` |
| `mix.exs` | `escript: [...]` | `mod: {GameOfStones.Application, []}` |
| Estado do Server | `{player, stones}` | `{player, stones, fase}` |

## Estrutura deste projeto

```
game_of_stones_ets/
├── mix.exs
├── lib/
│   ├── application.ex             # GameOfStones.Application — inicia o Supervisor
│   └── game_of_stones/
│       ├── server.ex              # GameOfStones.Server — GenServer supervisionado
│       ├── storage.ex             # GameOfStones.Storage — GenServer que gerencia ETS
│       └── client.ex              # GameOfStones.Client — loop interativo
└── test/
    ├── test_helper.exs
    └── game_of_stones_test.exs
```

## Application behaviour

O `mix.exs` define `mod: {GameOfStones.Application, []}`. Isso instrui o OTP a chamar `GameOfStones.Application.start/2` automaticamente quando a aplicação sobe — seja com `iex -S mix`, `mix run`, ou em produção.

```elixir
# lib/application.ex
defmodule GameOfStones.Application do
  use Application

  def start(_type, _args) do
    children = [
      GameOfStones.Storage,  # deve subir antes do Server
      GameOfStones.Server
    ]
    opts = [strategy: :one_for_one, name: GameOfStones.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

> **Ordem importa:** o `Storage` precisa estar na lista antes do `Server` para que a tabela ETS já exista quando o `Server.init/1` tentar buscar o estado salvo.

## Supervisor

O `Supervisor.start_link/2` recebe uma lista de **filhos** e uma **estratégia**:

| Estratégia | Comportamento ao falhar um filho |
|---|---|
| `:one_for_one` | Reinicia apenas o processo que falhou |
| `:one_for_all` | Reinicia todos os filhos |
| `:rest_for_one` | Reinicia o que falhou e todos iniciados depois dele |

Aqui usamos `:one_for_one` pois, se o `Server` cair, não há motivo para reiniciar o `Storage` (que ainda tem os dados no ETS).

## `start_link` vs `start`

Para que um processo seja **supervisionado**, ele precisa ser iniciado com `start_link/3` — que cria um **link** entre o Supervisor e o filho. Se o filho cair, o Supervisor é notificado via esse link e o reinicia conforme a estratégia.

```elixir
# start_link é obrigatório para supervisão
def start_link(_) do
  GenServer.start_link(__MODULE__, :started, name: __MODULE__)
end
```

Um processo iniciado com `GenServer.start/3` não tem link e o Supervisor nunca saberá se ele caiu.

## Estado do Server — máquina de estados

O Server agora rastreia a fase do jogo para evitar chamadas fora de ordem:

```
:started  -->  :game_in_progress  -->  :game_ended
```

| Fase | O que aceita |
|---|---|
| `:started` | `set_stones/1` |
| `:game_in_progress` | `take/1` |
| `:game_ended` | nenhuma chamada (processo parou) |

`set_stones/1` é chamado **uma única vez** no início. O loop do Client (`game_loop/2`) só chama `take/1`.

## Persistência de estado com ETS

**ETS (Erlang Term Storage)** é um mecanismo de armazenamento em memória **nativo do BEAM**, completamente fora do modelo de processos. Enquanto o estado de um GenServer vive dentro do processo e morre com ele, uma tabela ETS existe na VM e só é destruída quando o **processo dono** termina — independentemente de outros processos caírem ou reiniciarem.

O `Storage` cria a tabela no `init/1` e a mantém viva enquanto ele próprio existir. Por ser um GenServer supervisionado **separado** do `Server`, a tabela sobrevive à queda e ao reinício do `Server`.

```
 ETS table (:game_of_stones_storage)
 ┌─────────────────────────────────────────────────────┐
 │  key (num_stones) │  value                          │
 │──────────────────────────────────────────────────── │
 │  30               │  {1, 30, :game_in_progress}     │
 │  27               │  {2, 27, :game_in_progress}     │
 │  24               │  {1, 24, :game_in_progress}     │
 └─────────────────────────────────────────────────────┘
```

### Tipos de tabela

| Tipo | Chaves únicas? | Ordenado? | Uso típico |
|------|----------------|-----------|------------|
| `:set` | Sim (substitui duplicatas) | Não | cache, dicionário |
| `:ordered_set` | Sim (substitui duplicatas) | Sim (ascending, Erlang term order) | históricos, índices |
| `:bag` | Não (permite mesma chave com valores diferentes) | Não | índices invertidos |
| `:duplicate_bag` | Não (permite entradas 100% iguais) | Não | logs com duplicatas |

Este projeto usa `:ordered_set`: cada `num_stones` é chave única e a tabela mantém as entradas em ordem **ascendente** pela chave. Como pedras só diminuem, o estado mais recente (menor `num_stones`) fica **sempre na primeira posição** da lista retornada por `:ets.tab2list/1` — por isso `fetch/0` usa `hd(list)`.

### Modos de acesso

| Opção | Quem pode ler/escrever |
|-------|------------------------|
| `:public` | Qualquer processo |
| `:protected` | Processo dono escreve; qualquer um lê |
| `:private` | Apenas o processo dono |

`:private` foi escolhido porque toda leitura e escrita passa obrigatoriamente pelo `Storage` GenServer. Nenhum processo acessa a tabela diretamente — o encapsulamento é total.

### `:named_table`

Sem essa opção, `:ets.new/2` retorna um `tid` (table identifier) opaco que precisaria ser passado por parâmetro a cada chamada. Com `:named_table`, a tabela é registrada sob o atom `:game_of_stones_storage` e pode ser referenciada por nome em qualquer ponto do Storage:

```elixir
:ets.insert(:game_of_stones_storage, data)
:ets.tab2list(:game_of_stones_storage)
```

### `{:keypos, 2}` — chave no segundo campo

Por padrão o ETS usa o **primeiro elemento** da tupla como chave. Com `{:keypos, 2}`, o segundo elemento é promovido a chave. Como os registros são `{player, num_stones, fase}`, a chave passa a ser `num_stones`:

```elixir
# Tupla armazenada:
{1, 30, :game_in_progress}
# ^  ^   ^
# |  |   fase
# |  chave  (keypos: 2)  ← usada para busca, unicidade e ordenação
# player
```

Inserir `{2, 30, :game_in_progress}` (mesma chave `30`) **substituiria** a entrada anterior — comportamento de `:ordered_set`.

### Funções ETS usadas neste projeto

| Função | O que faz |
|--------|-----------|
| `:ets.new(name, opts)` | Cria a tabela; retorna `tid` (ou usa nome se `:named_table`) |
| `:ets.insert(table, tuple)` | Insere ou substitui a entrada com aquela chave |
| `:ets.tab2list(table)` | Retorna todos os registros como lista (ordenada em `:ordered_set`) |
| `:ets.delete_all_objects(table)` | Remove todos os registros sem destruir a tabela |

> `:ets.delete_all_objects/1` é chamado ao detectar um vencedor (`{:store, {:winner, _}}`), limpando o histórico para a próxima partida sem precisar recriar a tabela.

### Propriedade da tabela e sobrevivência ao crash

```
Supervisor
  ├── Storage GenServer ──owns──► ETS :game_of_stones_storage
  │                                       ▲
  │                               insert / tab2list
  │                                       │
  └── Server GenServer ─────────(cai e reinicia)
```

A tabela pertence ao **Storage**. Se o `Server` cai (por qualquer razão), o Storage e sua tabela continuam intactos. Ao reiniciar, `Server.init/1` chama `Storage.fetch/0`, que lê o estado mais recente do ETS e restaura a partida exatamente onde parou.

Se o **Storage** caísse, a tabela seria destruída junto e a persistência perdida. Para persistência além da sessão (reinicialização da VM), seria necessário um banco de dados ou arquivo.

### Performance

| Operação | `:set` | `:ordered_set` |
|----------|--------|----------------|
| Lookup por chave | O(1) | O(log n) |
| Inserção | O(1) | O(log n) |
| Iteração ordenada | N/A | O(n) |

O overhead de O(log n) do `:ordered_set` é negligível para os tamanhos de dados deste jogo, e o benefício de ter `tab2list` já ordenado (sem precisar de `Enum.sort`) justifica a escolha.

`fetch_all/0` é chamado ao final da partida para exibir o histórico completo via `IO.inspect`.

## O que acontece quando o Server falha

Com `restart: :transient`, o Supervisor reinicia o `Server` apenas se ele terminar com uma razão **anormal** (qualquer coisa que não seja `:normal` ou `:shutdown`). Ao reiniciar, `Server.init/1` chama `Storage.fetch/0`, que lê o estado mais recente do ETS e restaura exatamente onde o jogo parou.

```
Server crash ──► Supervisor detecta ──► reinicia Server
                                              │
                                              ▼
                                    init/1 → Storage.fetch/0
                                              │
                                              ▼
                                    ETS retorna último estado
                                    {player, stones, :game_in_progress}
```

Isso ilustra **"let it crash"**: em vez de blindar o processo contra todo erro possível, deixa-o morrer e confia no Supervisor + Storage para recuperar.

## Como testar a recuperação de estado

> `Client.play/1` fica bloqueado no `IO.gets` aguardando input — não é possível rodar outros comandos no mesmo IEx enquanto ele espera. Por isso, o teste é feito chamando o Server diretamente, sem passar pelo Client.

1. Inicie o IEx:
   ```bash
   iex -S mix
   ```

2. Avance alguns turnos chamando o Server diretamente:
   ```elixir
   iex> GameOfStones.Server.set_stones(15)
   iex> GameOfStones.Server.take(3)   # player 1 tira 3 → 12 pedras
   iex> GameOfStones.Server.take(2)   # player 2 tira 2 → 10 pedras
   ```

3. Confirme o que está salvo no ETS:
   ```elixir
   iex> GameOfStones.Storage.fetch_all()
   # [{1, 15, :game_in_progress}, {2, 12, :game_in_progress}, {1, 10, :game_in_progress}]
   ```

4. **Quebre o Server** — simule uma falha anormal:
   ```elixir
   iex> Process.exit(Process.whereis(GameOfStones.Server), :kill)
   # Você verá: "Starting Game of Stones Server..." — o Supervisor reiniciou
   ```

5. Retome a partida — o estado deve ter sido restaurado:
   ```elixir
   iex> GameOfStones.Client.play()
   # Deve imprimir: "Resuming game with Player 1 and 10 stones left."
   ```

> **`:kill` vs `:normal`:** `Process.exit(pid, :kill)` é irrecusável — o processo termina com razão `:killed` (anormal), disparando o reinício pelo Supervisor. Já `Process.exit(pid, :normal)` **não** reinicia (`restart: :transient` ignora saídas normais, que é exatamente o que acontece ao fim de uma partida).

## Como rodar

```bash
cd Course-03/07-fault-tolerance/game_of_stones
mix deps.get
iex -S mix
```

Dentro do `iex`, o Server já está rodando (iniciado pelo Application). Basta:

```elixir
GameOfStones.Client.play()       # 30 pedras (padrão)
GameOfStones.Client.play(10)     # 10 pedras
```

## Dependências externas

| Pacote | Versão | Uso |
|---|---|---|
| [`bunt`](https://hex.pm/packages/bunt) | `~> 1.0` | cores ANSI no terminal |

```elixir
[:cyan, "Player 1's turn."] |> Bunt.puts()
[:yellow, "Player 2's turn."] |> Bunt.puts()
[:green, :bright, "Player 2 wins!"] |> Bunt.puts()
[:red, "Error: ..."] |> Bunt.puts()
```

