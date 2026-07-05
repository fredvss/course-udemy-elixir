# Pattern Matching — Exercícios de matching e guards

Projeto Mix focado em **pattern matching**, múltiplas cláusulas de função e **guard clauses** — conceitos centrais do Elixir usados em todo o ecossistema.

## Conceitos

- Pattern matching em tuplas `{:ok, _}` / `{:error, _}`
- Múltiplas cláusulas de função (uma por padrão)
- Guards: `when n > 0`, `when is_binary/1`, `when is_integer/1`
- Matching em mapas e listas
- Doctest para validar exemplos

## Como usar

```bash
cd Basics/pattern_matching

mix test
iex -S mix
```

No IEx:

```elixir
PatternMatching.Exercises.classify({:ok, "dados"})
PatternMatching.Exercises.describe_number(-1)
PatternMatching.Exercises.parse_int("99")
```

## Módulo

### `PatternMatching.Exercises`

| Função | Descrição |
|--------|-----------|
| `classify/1` | `:success`, `:failure` ou `:unknown` conforme a tupla |
| `head/1` | Primeiro elemento de uma lista |
| `describe_number/1` | `:positive`, `:zero` ou `:negative` com guards |
| `parse_int/1` | String → `{:ok, int}` ou `{:error, :invalid}` |
| `user_info/1` | Extrai `name` e `age` de um mapa de usuário |

## Testes

```bash
mix test
```

## Próximos passos

- [file_io](../file_io/) — I/O de arquivos com tuplas de resultado
- [Course-01/01-fizz-buzz](../../Course-01/01-fizz-buzz/) — FizzBuzz com guards
