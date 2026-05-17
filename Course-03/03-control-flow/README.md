# 03 - Control Flow

Controle de fluxo e tratamento de erros em Elixir.

## Condicionais

### `if` / `unless`

Forma mais simples. `unless` é o oposto de `if`.

```elixir
if x > 0, do: "positivo", else: "não positivo"
unless x == 0, do: IO.puts("não é zero")
```

### `case`

Pattern matching sobre um valor. Cada cláusula pode ter guards.

```elixir
case resultado do
  {:ok, valor}    -> "sucesso: #{valor}"
  {:error, motivo} -> "erro: #{motivo}"
  _               -> "outro"
end
```

### `cond`

Equivalente a múltiplos `if/else if`. Executa a primeira cláusula verdadeira.

```elixir
cond do
  x > 100 -> "grande"
  x > 10  -> "médio"
  true    -> "pequeno"   # cláusula padrão
end
```

## Exceções

### `raise` / `rescue`

Erros esperados e recupéravéis. Use para situações excepcionais de runtime.

```elixir
try do
  Keyword.fetch!([a: 1], :b)
rescue
  KeyError   -> "chave não encontrada"
  e in RuntimeError -> e.message
after
  IO.puts("sempre executado")   # equivalente ao `finally`
else
  valor -> "sem erros, valor: #{valor}"   # só executado se não houve erro
end
```

### `throw` / `catch`

Mecanismo de controle de fluxo não-local. Não é para erros — use para interromper computações (ex.: early return em recursões).

```elixir
try do
  throw(:encontrado)
catch
  :encontrado -> "achou!"
end
```

### `exit`

Encerramentos de processo. Raramente usado diretamente fora de OTP.

```elixir
exit(:normal)    # encerramento normal
exit(:shutdown)  # encerramento supervisionado
```

## Quando usar cada um

| Mecanismo | Use quando |
|-----------|------------|
| `if/case/cond` | Lógica condicional normal |
| `raise/rescue` | Erros recupéravéis, validações |
| `throw/catch` | Controle de fluxo não-local |
| `exit` | Encerrar processo intencionalmente |

## Subpastas

| Pasta | Conteúdo |
|-------|----------|
| `conditionals` | Condicionais: `if`, `unless`, `case` e `cond` |
| `exceptions` | Exceções: `raise`, `try/rescue`, `throw` e `exit` |

## Comandos úteis

```bash
elixir conditionals/case.exs
elixir conditionals/cond.exs
elixir conditionals/if-else.exs
elixir exceptions/raise.exs
elixir exceptions/try-rescue.exs
elixir exceptions/throw.exs
elixir exceptions/exits.exs
```
