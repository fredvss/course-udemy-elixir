# Elixir Executable — CLI com escript

Mini-projeto Mix que gera um executável de linha de comando via **escript**. Demonstra como empacotar código Elixir como binário standalone, receber argumentos do terminal e inspecionar valores.

## Conceitos

- `mix new` e estrutura de projeto
- Configuração de escript em `mix.exs` (`escript: [main_module: CLI]`)
- Ponto de entrada `CLI.main/1`
- Argumentos da linha de comando como lista de strings
- `mix escript.build` e execução do binário gerado

## Como usar

```bash
cd Basics/elixir_executable

# Rodar diretamente com mix
mix run -e "CLI.main([\"foo\", \"bar\"])"

# Gerar o executável
mix escript.build

# Executar o binário (argumentos após --)
./elixir_executable -- foo bar
```

Saída esperada:

```text
Argumentos recebidos: ["foo", "bar"]
```

## Estrutura

```text
elixir_executable/
├── lib/cli.ex          # módulo principal com main/1
├── mix.exs             # configuração do projeto e escript
├── test/               # testes ExUnit
└── elixir_executable   # binário gerado por mix escript.build
```

## Testes

```bash
mix test
```

## Próximos passos

- Parsear flags (`--help`, `--version`)
- Subcomandos com pattern matching nos argumentos
- Saída formatada com `IO.puts/1` em vez de `IO.inspect/2`
