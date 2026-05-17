# 02 - Iterations

Iteração e processamento de coleções em Elixir. Em vez de loops imperativos (`for`, `while`), Elixir usa **recursão**, **Enum** e **Stream**.

## Recursão

Base de toda iteração. Funções se chamam recursivamente com uma cláusula base para parar.

```elixir
def factorial(0), do: 1
def factorial(n), do: n * factorial(n - 1)
```

### Tail Call Optimization (TCO)

Quando a chamada recursiva é a última operação da função, o compilador reutiliza o stack frame — sem risco de stack overflow mesmo com milhões de iterações.

```elixir
# Sem TCO (acumula stack frames)
def fact(0), do: 1
def fact(n), do: n * fact(n - 1)   # multiplicação DEPOIS da chamada recursiva

# Com TCO (acumulador como argumento)
def fact(n), do: do_fact(1, n)
defp do_fact(acc, 0), do: acc
defp do_fact(acc, n), do: do_fact(acc * n, n - 1)   # chamada recursiva é a última op
```

## Enum

Módulo para processar qualquer `Enumerable` (listas, mapas, ranges) de forma **eager** (avalia tudo de uma vez).

```elixir
Enum.map([1, 2, 3], &(&1 * 2))          # [2, 4, 6]
Enum.filter([1, 2, 3, 4], &rem(&1,2) == 0)  # [2, 4]
Enum.reduce([1,2,3], 0, &(&1 + &2))     # 6
Enum.sort([3,1,2])                       # [1, 2, 3]
Enum.group_by([1,2,3,4], &rem(&1,2))    # %{0 => [2,4], 1 => [1,3]}
```

## Stream

Processamento **lazy**: os elementos são gerados um a um, apenas quando necessário. Ideal para coleções grandes ou infinitas.

```elixir
# Só processa os 5 primeiros, sem criar a lista inteira
Stream.iterate(1, &(&1 * 2))   # stream infinito: 1, 2, 4, 8, ...
|> Enum.take(5)                # [1, 2, 4, 8, 16]

# Pipeline lazy com arquivo
File.stream!("arquivo.txt")
|> Stream.map(&String.trim/1)
|> Stream.filter(&(&1 != ""))
|> Enum.to_list()
```

## Compreensões (`for`)

Sintaxe concisa para gerar, filtrar e transformar coleções. Suporta múltiplos geradores e guards.

```elixir
for x <- 1..5, rem(x, 2) == 0, do: x * 10
# [20, 40]

# Produto cartesiano
for x <- [1,2], y <- [:a,:b], do: {x, y}
# [{1,:a},{1,:b},{2,:a},{2,:b}]

# Coletando em mapa
for {k, v} <- [a: 1, b: 2], into: %{}, do: {k, v * 10}
# %{a: 10, b: 20}
```

## Enum vs Stream: quando usar cada um

| | Enum | Stream |
|---|------|--------|
| Avaliação | Imediata (eager) | Lazy (sob demanda) |
| Coleções infinitas | Não | Sim |
| Pipelines longas | Cria lista intermediária a cada passo | Uma única passagem |
| Arquivos grandes | Carrega tudo na memória | Processa linha a linha |

## Subpastas

| Pasta | Conteúdo |
|-------|----------|
| `01-recursion` | Recursão básica: fatorial e map recursivo |
| `02-recursion-lists` | Recursão sobre listas: encontrando o valor máximo |
| `03-tail-call-optimization` | Otimização de chamada de cauda (TCO) com acumulador |
| `04-enum-collections` | Módulo `Enum`, `List`, `Map` e keyword lists |
| `05-streams` | Processamento lazy com o módulo `Stream` |
| `06-streams-files` | Leitura lazy de arquivos com `File.stream!` |
| `07-comprehensions` | Compreensões de lista com `for` |

## Comandos úteis

```bash
elixir 01-recursion/recursion.exs
elixir 03-tail-call-optimization/tail_call.exs
elixir 04-enum-collections/enum.exs
elixir 05-streams/streams.exs
elixir 07-comprehensions/comprehensions.exs

# Explorar Enum/Stream no IEx
iex> Enum.map(1..10, &(&1 * &1))
iex> Stream.cycle([1,2,3]) |> Enum.take(7)
iex> 1..1_000_000 |> Stream.filter(&rem(&1,2)==0) |> Enum.take(5)
```
