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

O `Storage` cria uma tabela ETS no `init/1` e a mantém viva enquanto o próprio processo existir. Por ser um GenServer supervisionado separado, a tabela ETS sobrevive à queda do `Server`.

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

A tabela usa `{:keypos, 2}` — o segundo elemento da tupla (`num_stones`) é a chave. Como pedras só diminuem, cada turno cria uma nova entrada, formando um histórico da partida. O estado mais recente é sempre o de **menor** `num_stones` (primeira entrada num `:ordered_set`, que ordena de forma ascendente).

`fetch_all/0` é chamado ao final da partida (quando um jogador vence) para exibir o histórico completo via `IO.inspect`.

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

