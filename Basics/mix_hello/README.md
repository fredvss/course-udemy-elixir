# Mix Hello — Primeiro projeto Mix com testes

Introdução ao fluxo de trabalho com **Mix**: criar um módulo documentado, rodar testes com ExUnit e validar exemplos com **doctest**.

## Conceitos

- Estrutura padrão de projeto Mix (`lib/`, `test/`, `mix.exs`)
- `@moduledoc` e `@doc` para documentação
- ExUnit: `mix test`, `use ExUnit.Case`
- Doctest: exemplos em `@doc` viram testes automáticos
- Valores padrão em parâmetros de função

## Como usar

```bash
cd Basics/mix_hello

# Compilar e rodar testes (inclui doctests)
mix test

# Abrir IEx com o projeto carregado
iex -S mix
```

No IEx:

```elixir
MixHello.greet("Phoenix")
MixHello.add(10, 32)
h MixHello.greet/1
```

## Estrutura

```text
mix_hello/
├── lib/mix_hello.ex    # módulo com @doc e exemplos
├── test/               # testes ExUnit + doctest
└── mix.exs
```

## Testes

```bash
mix test
```

Os doctests validam os exemplos em `lib/mix_hello.ex`. O teste em `test/mix_hello_test.exs` complementa com um caso adicional.

## Próximos passos

- [pattern_matching](../pattern_matching/) — pattern matching e guards
- [elixir_basics_complete.md](../../docs/elixir_basics_complete.md) — módulos e funções
