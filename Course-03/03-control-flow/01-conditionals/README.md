# 01 - Condicionais

Estrutura de controle de fluxo condicional em Elixir.

## Arquivos

| Arquivo | Conteúdo |
|---------|----------|
| `if-else.exs` | Uso de `if`, `unless` e `else` para desvios simples |
| `case.exs` | Pattern matching com `case` — aplicado a args de CLI com `OptionParser` |
| `cond.exs` | Avaliação de múltiplas condições com `cond` (equivalente a `else if`) |

## Conceitos

- **`if` / `unless`** — desvio condicional simples; `unless` é o inverso de `if`.
- **`case`** — faz pattern matching sobre um valor; suporta cláusula de fallback com `_`.
- **`cond`** — avalia uma lista de expressões booleanas e executa a primeira verdadeira; a cláusula `true ->` serve de fallback.
