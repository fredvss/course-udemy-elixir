# Game of Stones — Projeto Mix + Escript

Versão do Game of Stones como projeto Mix completo, com escript (executável) e terminal colorido via biblioteca externa [`bunt`](https://hex.pm/packages/bunt).

## Mix new

O comando `mix new <app>` gera automaticamente:

```
<app>/
├── .formatter.exs   # config do mix format
├── .gitignore
├── mix.exs          # config do projeto (deps, escript, etc.)
├── README.md
├── lib/
│   └── <app>.ex
└── test/
    ├── test_helper.exs
    └── <app>_test.exs
```

> **`config/`** (ex.: `config/config.exs`) **não é criado pelo `mix new`**. Ele aparece em projetos Phoenix ou é adicionado manualmente quando necessário.

## Estrutura deste projeto

```
game_of_stones/
├── .formatter.exs
├── mix.exs
├── lib/
│   ├── game_of_stones.ex          # entry point do escript (main/1)
│   └── game_of_stones/
│       ├── server.ex              # GameOfStones.Server — GenServer
│       └── client.ex              # GameOfStones.Client — loop interativo com cores
└── test/
    ├── test_helper.exs
    └── game_of_stones_test.exs    # testes do GameOfStones.Server
```

## Dependências externas

| Pacote | Versão | Uso |
|---|---|---|
| [`bunt`](https://hex.pm/packages/bunt) | `~> 1.0` | 256 cores ANSI no terminal |

`bunt` usa uma API de lista onde cada átomo representa um atributo de cor ou estilo:

```elixir
[:cyan, "texto em ciano"] |> Bunt.puts()
[:red, :bright, "texto vermelho e brilhante"] |> Bunt.puts()
```

## Como rodar

### 1. Instalar dependências

```bash
cd Course-03/06-mix-tool/game_of_stones
mix deps.get
```

### 2. Executar direto com Mix

```bash
mix run -e "GameOfStones.Client.play()"
mix run -e "GameOfStones.Client.play(10)"   # 10 pedras
```

### 3. Gerar e usar o escript

```bash
mix escript.build
./game_of_stones          # 30 pedras (padrão)
./game_of_stones 10       # 10 pedras
```

O escript é um executável portável: basta ter o Erlang instalado na máquina de destino, sem precisar do Elixir ou do projeto Mix.

## Escript — como funciona

O `mix.exs` define `escript: [main_module: GameOfStones]`. O Mix compila todos os módulos do projeto (e suas deps) em um único arquivo binário executável. O ponto de entrada é `GameOfStones.main/1`, que recebe os argumentos de linha de comando como **lista de strings**.

| Comando | `args` recebido |
|---|---|
| `./game_of_stones` | `[]` |
| `./game_of_stones 10` | `["10"]` |
| `./game_of_stones 10 foo` | `["10", "foo"]` |

Por isso o `parse_args/1` converte a string para inteiro — tudo chega como texto.

```elixir
# lib/game_of_stones.ex
def main(args) do
  num_stones = parse_args(args)   # "10" -> 10
  GameOfStones.Client.play(num_stones)
end
```

## Colorize — como funciona

`bunt` usa uma API de lista onde átomos representam cores e atributos ANSI:

```elixir
[:cyan, "Player 1's turn."] |> Bunt.puts()
[:yellow, "Player 2's turn."] |> Bunt.puts()
[:green, :bright, "Player 2 wins!"] |> Bunt.puts()
[:red, "Error: ..."] |> Bunt.puts()
```
