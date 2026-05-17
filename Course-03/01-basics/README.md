# 01 - Basics

Fundamentos da linguagem Elixir.

## Tipos de dados nativos

```elixir
# Números
42          # integer
3.14        # float
0xFF        # hex
0b1010      # bin
1_000_000   # separador visual

# Atoms
:ok
:error
:my_atom
true        # atom
false       # atom
nil         # atom

# Strings (binárias, UTF-8)
"olá mundo"
"#{1 + 1}"  # interpolação

# Listas (linked list)
[1, 2, 3]
[head | tail] = [1, 2, 3]   # head = 1, tail = [2, 3]

# Tuplas (acesso O(1), imutáveis)
{:ok, 42}
{:error, "mensagem"}

# Mapas
%{nome: "Alice", idade: 30}
%{"chave" => "valor"}

# Keyword lists (listas de tuplas {atom, valor})
[debug: true, timeout: 5000]
```

## Módulos e funções

```elixir
defmodule Saudacao do
  def ola(nome), do: "Olá, #{nome}!"
  defp privada, do: "só acessível internamente"
end

Saudacao.ola("Alice")  # "Olá, Alice!"
```

## Aridade, guards e cláusulas

Funções com o mesmo nome e aridades diferentes são funções distintas. Cláusulas permitem pattern matching direto nos parâmetros. Guards restringem com condições.

```elixir
defmodule Calc do
  def dobro(n) when is_number(n), do: n * 2

  def descreve(0),                    do: "zero"
  def descreve(n) when n > 0,         do: "positivo"
  def descreve(_),                    do: "negativo"
end
```

## Lambdas (funções anônimas)

```elixir
dobro = fn x -> x * 2 end
dobro.(5)   # 10

# Captura curta
triplo = &(&1 * 3)
triplo.(4)  # 12

# Captura de função nomeada
IO.puts("olá")  # função nomeada
f = &IO.puts/1  # captura pela aridade
f.("olá")
```

## Imutabilidade e pipe operator

Todo valor em Elixir é imutável. O operador `|>` passa o resultado da expressão anterior como primeiro argumento.

```elixir
"  olá mundo  "
|> String.trim()
|> String.upcase()
|> String.split()
# ["OLÁ", "MUNDO"]
```

## Subpastas

| Pasta | Conteúdo |
|-------|----------|
| `01-built-in-data-types` | Tipos nativos: atoms, booleans, números, strings, listas, mapas, tuplas e keyword lists |
| `02-modules-functions` | Definição de módulos e funções nomeadas |
| `03-functions-arity-guards-clauses` | Aridade, guards e cláusulas de função |
| `04-lambda-functions` | Funções anônimas (lambdas) e closures |

## Comandos úteis

```bash
# Rodar qualquer script
elixir 01-built-in-data-types/maps.exs
elixir 02-modules-functions/modules_functions.ex

# IEx — console interativo
iex
iex> h String          # documentação do módulo
iex> h String.split    # documentação da função
iex> i "hello"         # inspeciona tipo e valor
iex> v(3)              # recupera resultado da linha 3
iex> recompile()       # recompila o projeto atual
```
