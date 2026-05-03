# 02 - Exceções

Mecanismos de tratamento de erros em Elixir: `raise`, `throw` e `exit`.

## Arquivos

| Arquivo | Conteúdo |
|---------|----------|
| `raise.exs` | Definição de exceção customizada com `defexception` e uso de `raise` |
| `try-rescue.exs` | Captura de erros com `try/rescue`; blocos `after` (finally) e `else` |
| `throw.exs` | Uso de `throw` e `catch` para fluxo não-local |
| `exits.exs` | Captura de sinais de saída de processo com `exit` e `catch :exit` |

## Conceitos

- **`raise` / `defexception`** — levanta exceções; é possível definir exceções customizadas com `defexception`.
- **`try/rescue`** — captura exceções por tipo; `after` sempre executa (equivalente a `finally`); `else` executa somente quando não há erros.
- **`throw/catch`** — mecanismo para desvio de fluxo não-local, normalmente usado fora do escopo de erros.
- **`exit/catch :exit`** — sinaliza a saída de um processo; pode ser interceptado com `catch :exit, reason`.
