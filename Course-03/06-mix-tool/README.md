# 06 - Mix Tool

`mix` é a ferramenta de build integrada ao Elixir. Ela gerencia projetos, dependências, tarefas, testes e muito mais.

## `mix new`

Cria a estrutura padrão de um projeto:

```bash
mix new my_app
mix new my_app --module MyApp   # nome do módulo personalizado
mix new my_app --sup            # inclui Application + Supervisor
```

Estrutura gerada:

```
my_app/
├── .formatter.exs   # configuração do mix format
├── .gitignore
├── mix.exs          # configuração do projeto
├── README.md
├── lib/
│   └── my_app.ex
└── test/
    ├── test_helper.exs
    └── my_app_test.exs
```

## `mix.exs`

Arquivo central do projeto. Define metadados, dependências e configurações de build:

```elixir
defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,
      version: "0.1.0",
      elixir: "~> 1.17",
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:bunt, "~> 1.0"}
    ]
  end
end
```

## Dependências

| Comando | Descrição |
|---------|-----------|
| `mix deps.get` | Baixa todas as dependências declaradas em `mix.exs` |
| `mix deps.update <pacote>` | Atualiza um pacote específico |
| `mix deps.clean --all` | Remove todos os artefatos compilados das deps |

As dependências ficam em `deps/` (fonte) e `_build/` (compilado). O arquivo `mix.lock` trava as versões exatas.

### Operadores de versão (SemVer)

| Operador | Exemplo | Significado |
|----------|---------|-------------|
| `~>` | `~> 1.2` | `>= 1.2.0 e < 2.0.0` |
| `~>` | `~> 1.2.3` | `>= 1.2.3 e < 1.3.0` |
| `>=` | `>= 1.0.0` | qualquer versão >= 1.0.0 |
| `==` | `== 1.2.3` | exatamente esta versão |

## Tarefas comuns

| Comando | Descrição |
|---------|-----------|
| `mix compile` | Compila o projeto |
| `mix test` | Roda os testes (`test/**/*_test.exs`) |
| `mix format` | Formata o código conforme `.formatter.exs` |
| `mix run -e "Mod.func()"` | Executa uma expressão Elixir no contexto do projeto |
| `iex -S mix` | Abre o IEx com o projeto carregado |

## Escript

Um **escript** é um executável portável gerado a partir do projeto. Requer apenas o Erlang na máquina de destino — não precisa do Elixir ou do projeto Mix.

```elixir
# mix.exs
def project do
  [
    ...,
    escript: [main_module: MyApp]
  ]
end
```

```elixir
# lib/my_app.ex
defmodule MyApp do
  def main(args) do
    # args é uma lista de strings (argumentos de linha de comando)
    IO.puts("Hello from escript! Args: #{inspect(args)}")
  end
end
```

```bash
mix escript.build
./my_app arg1 arg2
```

## Testes com ExUnit

O Mix integra o framework de testes `ExUnit`. Os arquivos de teste ficam em `test/` e terminam com `_test.exs`.

```elixir
defmodule MyAppTest do
  use ExUnit.Case

  test "soma dois números" do
    assert MyApp.sum(1, 2) == 3
  end

  test "retorna erro para entrada inválida" do
    assert {:error, _} = MyApp.sum(:invalid, 2)
  end
end
```

```bash
mix test                        # roda todos os testes
mix test test/my_app_test.exs   # roda um arquivo específico
mix test --trace                # saída detalhada
```

## Projeto desta seção

| Pasta | Conteúdo |
|-------|----------|
| `game_of_stones/` | Game of Stones como projeto Mix completo com escript e terminal colorido via `bunt` |
