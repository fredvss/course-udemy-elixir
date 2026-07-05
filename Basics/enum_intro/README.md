# Enum Intro — Coleções e transformações

Projeto Mix focado no módulo `Enum` e em **list comprehensions** — a base da composição funcional em Elixir, usada em todo o ecossistema (incluindo Phoenix e Ecto).

## Conceitos

- `Enum.map/2` — transformar cada elemento
- `Enum.filter/2` — manter elementos que passam no predicado
- `Enum.reduce/3` — acumular um valor (soma, concatenação, etc.)
- `Enum.count/2`, `Enum.group_by/3`, `Enum.join/2`
- Pipe `|>` encadeando operações
- Comprehensions: `for x <- lista, condição, do: expr`

## Como usar

```bash
cd Basics/enum_intro

mix test
iex -S mix
```

No IEx:

```elixir
EnumIntro.Examples.double([1, 2, 3])
EnumIntro.Examples.square_evens(1..10)
EnumIntro.Examples.format_scores([90, 45, 72, 30])
```

## Módulo

### `EnumIntro.Examples`

| Função | Descrição |
|--------|-----------|
| `double/1` | Dobra cada número |
| `evens/1` | Filtra pares |
| `sum/1` | Soma com `reduce` |
| `count_greater_than/2` | Conta elementos acima de um limiar |
| `group_by_length/1` | Agrupa palavras por tamanho |
| `square_evens/1` | Quadrados dos pares (comprehension) |
| `vowel_positions/1` | Posições das vogais (comprehension) |
| `format_scores/1` | Pipeline completo com pipe |

## Testes

```bash
mix test
```

## Próximos passos

- [mix_tasks](../mix_tasks/) — tarefas Mix customizadas
- [Course-02/01-cards](../../Course-02/01-cards/) — Enum em um projeto real
