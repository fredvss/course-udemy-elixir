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
game_of_stones/
├── mix.exs
├── lib/
│   ├── application.ex             # GameOfStones.Application — inicia o Supervisor
│   └── game_of_stones/
│       ├── server.ex              # GameOfStones.Server — GenServer supervisionado
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
    children = [GameOfStones.Server]
    opts = [strategy: :one_for_one, name: GameOfStones.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

## Supervisor

O `Supervisor.start_link/2` recebe uma lista de **filhos** e uma **estratégia**:

| Estratégia | Comportamento ao falhar um filho |
|---|---|
| `:one_for_one` | Reinicia apenas o processo que falhou |
| `:one_for_all` | Reinicia todos os filhos |
| `:rest_for_one` | Reinicia o que falhou e todos iniciados depois dele |

Aqui usamos `:one_for_one` pois o Server é o único filho.

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

## O que acontece quando o Server falha

Com supervisão, se o Server levantar uma exceção e terminar de forma anormal, o Supervisor o reinicia com o estado inicial `{1, 0, :started}`. O jogo precisa ser iniciado novamente com `set_stones/1`.

Isso ilustra uma característica importante do OTP: **"let it crash"** — em vez de tratar todos os erros internamente, deixa o processo morrer e confia no Supervisor para recuperar.

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

