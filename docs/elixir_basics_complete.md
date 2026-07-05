# Elixir Basics — Handbook Completo

## 1. Tipos de Dados

### Integers

```elixir
42            # decimal
0b1010        # binário  → 10
0o17          # octal    → 15
0xFF          # hex      → 255
1_000_000     # separador visual
```

### Floats

```elixir
3.14
1.0e-2        # notação científica → 0.01
```

### Atoms

Constantes cujo nome é seu próprio valor. Imutáveis, armazenados em tabela global.

```elixir
:ok
:error
:hello
true          # é o atom :true
false         # é o atom :false
nil           # é o atom :nil
MyModule      # módulos são atoms
```

### Strings

UTF-8 por padrão. Internamente são binários (`<<...>>`).

```elixir
"olá mundo"
"linha 1
linha 2"
"interpolação: #{1 + 1}"       # "interpolação: 2"
```

Funções essenciais:

```elixir
String.length("elixir")             # 6
String.upcase("hello")              # "HELLO"
String.downcase("HELLO")            # "hello"
String.split("a,b,c", ",")          # ["a", "b", "c"]
String.trim("  hi  ")               # "hi"
String.contains?("hello", "ell")    # true
String.starts_with?("hello", "he")  # true
String.ends_with?("hello", "lo")    # true
String.replace("foo bar", "foo", "baz")  # "baz bar"
String.slice("hello", 1, 3)         # "ell"
String.at("hello", 0)               # "h"
String.reverse("hello")             # "olleh"
String.duplicate("ab", 3)           # "ababab"
String.pad_leading("5", 3, "0")     # "005"
String.pad_trailing("hi", 5, ".")   # "hi..."
String.to_integer("42")             # 42
String.to_float("3.14")             # 3.14
String.to_atom("hello")             # :hello
Integer.to_string(42)               # "42"
to_string(:atom)                    # "atom"
```

### Binaries e Bitstrings

```elixir
<<65, 66, 67>>           # "ABC"
byte_size("hello")       # 5
is_binary("hello")       # true
```

### Charlists

Lista de codepoints. Use apenas ao interagir com Erlang.

```elixir
~c(hello)   # [104, 101, 108, 108, 111]
?h          # 104  (codepoint)
```

### nil

```elixir
nil            # atom :nil, valor falsy
is_nil(nil)    # true
is_nil(false)  # false
```

---

## 2. Operadores

### Aritméticos

```elixir
5 + 2           # 7
5 - 2           # 3
5 * 2           # 10
5 / 2           # 2.5  (sempre float)
div(5, 2)       # 2    (divisão inteira)
rem(5, 2)       # 1    (resto)
abs(-5)         # 5
Integer.pow(2, 10)    # 1024
:math.sqrt(9.0)       # 3.0
:math.pi()            # 3.141592653589793
```

### Comparação

```elixir
1 == 1.0     # true  (coerção de tipo)
1 === 1.0    # false (estrita — tipo e valor)
1 != 2       # true
1 !== 1.0    # true
```

Ordem universal de tipos:
`number < atom < reference < function < port < pid < tuple < map < list < bitstring`

### Lógicos

```elixir
# Estritos (só boolean)
true and false    # false
true or false     # true
not true          # false

# Short-circuit (qualquer valor)
1 && nil          # nil
nil || "default"  # "default"
!nil              # true
!0                # false  (0 é truthy em Elixir!)
```

### String e List

```elixir
"Hello" <> " World"      # "Hello World"
[1, 2] ++ [3, 4]         # [1, 2, 3, 4]
[1, 2, 3] -- [2]         # [1, 3]
```

---

## 3. Pattern Matching

`=` é o operador de match, não de atribuição.

```elixir
# Tuplas
{a, b, c} = {1, 2, 3}

# Listas
[head | tail] = [1, 2, 3]
# head=1, tail=[2,3]
[first, second | rest] = [1, 2, 3, 4]

# Maps (casam parcialmente)
%{name: name} = %{name: "Alice", age: 30}

# Strings
"hello " <> name = "hello Alice"
# name = "Alice"

# Ignorar com _
{_, value} = {:ignore, 42}

# Tuplas aninhadas
{:ok, {user, role}} = {:ok, {"alice", :admin}}

# Padrão em case
case response do
  {:ok, %{status: 200, body: body}} -> body
  {:ok, %{status: 404}}             -> nil
  {:error, reason}                  -> raise inspect(reason)
end
```

### Pin Operator `^`

Impede rebind: verifica o valor atual sem sobrescrever.

```elixir
x = 1
^x = 1    # ok
^x = 2    # ** (MatchError)

# Em case
case input do
  ^expected -> :match
  _         -> :no_match
end
```

### Pattern Matching em funções

```elixir
defmodule HTTP do
  def handle({:ok, %{status: 200, body: body}}), do: {:ok, body}
  def handle({:ok, %{status: 404}}),              do: {:error, :not_found}
  def handle({:ok, %{status: s}}),                do: {:error, {:http, s}}
  def handle({:error, reason}),                   do: {:error, {:network, reason}}
end
```

---

## 4. Control Flow

### if / unless

```elixir
if age >= 18 do
  :adult
else
  :minor
end

unless logged_in? do
  redirect("/login")
end

# inline
if ready?, do: :go, else: :wait
```

### cond

Avalia condições sequencialmente.

```elixir
cond do
  x > 100 -> :huge
  x > 10  -> :big
  x > 0   -> :positive
  x == 0  -> :zero
  true    -> :negative   # catch-all obrigatório
end
```

### case

Pattern matching com guards opcionais.

```elixir
case File.read("config.json") do
  {:ok, content}    -> Jason.decode!(content)
  {:error, :enoent} -> %{}
  {:error, reason}  -> raise "Erro: #{inspect(reason)}"
end

case value do
  n when is_integer(n) and n > 0 -> :positive_int
  n when is_float(n)              -> :float
  s when is_binary(s)             -> :string
  _                               -> :other
end
```

### with

Encadeia matches. Sai no primeiro que falhar.

```elixir
with {:ok, user}    <- fetch_user(id),
     {:ok, profile} <- fetch_profile(user.id),
     {:ok, posts}   <- fetch_posts(user.id) do
  render(user, profile, posts)
else
  {:error, :not_found}    -> {:error, :user_not_found}
  {:error, reason}        -> {:error, reason}
end
```

---

## 5. Funções

### Funções nomeadas

```elixir
defmodule Math do
  def add(a, b), do: a + b

  def factorial(0), do: 1
  def factorial(n) when n > 0, do: n * factorial(n - 1)
end
```

### Argumentos padrão

```elixir
def greet(name, greeting \ "Hello") do
  "#{greeting}, #{name}!"
end

greet("Alice")         # "Hello, Alice!"
greet("Alice", "Oi")   # "Oi, Alice!"
```

Com multi-clause, declare o padrão em cláusula sem corpo:

```elixir
def greet(name, greeting \ "Hello")
def greet(name, greeting), do: "#{greeting}, #{name}!"
```

### Guards

```elixir
def classify(n) when is_integer(n) and n > 0,  do: :positive_int
def classify(n) when is_integer(n) and n < 0,  do: :negative_int
def classify(0),                                do: :zero
def classify(n) when is_float(n),               do: :float
def classify(_),                                do: :other

# Guards built-in: is_integer/1, is_float/1, is_number/1, is_atom/1,
# is_binary/1, is_list/1, is_map/1, is_tuple/1, is_nil/1, is_boolean/1,
# is_function/1, is_pid/1, length/1, map_size/1, tuple_size/1,
# abs/1, rem/2, div/2, elem/2, hd/1, tl/1
```

### Funções anônimas

```elixir
double = fn x -> x * 2 end
double.(5)    # 10  — note o ponto

# Shorthand com &
double = &(&1 * 2)
add    = &(&1 + &2)
add.(3, 4)    # 7

# Capturar função nomeada
inspect_fn = &IO.inspect/1
Enum.map([1, 2, 3], &Math.factorial/1)

# Clausura
multiplier = 3
triple = fn x -> x * multiplier end
triple.(4)    # 12
```

### Funções privadas

```elixir
defmodule Parser do
  def parse(input), do: input |> clean() |> tokenize()
  defp clean(str),    do: String.trim(str)
  defp tokenize(str), do: String.split(str)
end
```

---

## 6. Módulos

```elixir
defmodule MyApp.Accounts.User do
  @moduledoc "Gerencia dados de usuários."

  @vsn "1.0"
  @default_role :viewer

  @doc "Cria um novo usuário"
  @spec new(String.t(), atom()) :: map()
  def new(name, role \ @default_role) do
    %{name: name, role: role}
  end
end
```

### alias / import / require

```elixir
# alias
alias MyApp.Accounts.User
alias MyApp.Accounts.User, as: U
alias MyApp.{Accounts, Auth, Billing}

# import — traz funções ao escopo local
import Enum, only: [map: 2, filter: 2]
import Kernel, except: [inspect: 1]

# require — carrega macros em compile-time
require Logger
Logger.info("msg")
require Integer
Integer.is_even(4)    # é uma macro
```

---

## 7. Collections

### List

```elixir
list = [1, 2, 3, 4, 5]

hd(list)                       # 1
tl(list)                       # [2, 3, 4, 5]
length(list)                   # 5
[0 | list]                     # [0, 1, 2, 3, 4, 5]  — prepend O(1)
list ++ [6]                    # append — O(n)
list -- [3]                    # [1, 2, 4, 5]

Enum.at(list, 2)               # 3
List.first(list)               # 1
List.last(list)                # 5
List.insert_at(list, 2, :x)    # [1, 2, :x, 3, 4, 5]
List.delete_at(list, 0)        # [2, 3, 4, 5]
List.flatten([[1, [2]], [3]])   # [1, 2, 3]
```

### Tuple

```elixir
t = {:ok, "result", 42}

elem(t, 0)                # :ok
tuple_size(t)             # 3
put_elem(t, 1, "novo")    # {:ok, "novo", 42}
Tuple.append(t, :extra)   # {:ok, "result", 42, :extra}
Tuple.to_list(t)          # [:ok, "result", 42]
```

Contíguo na memória → leitura O(1), cópia O(n). Use para dados de tamanho fixo.

### Map

```elixir
m = %{name: "Alice", age: 30}

# Acesso
m.name                              # "Alice"
m[:missing]                         # nil  (sem KeyError)
Map.get(m, :name)                   # "Alice"
Map.get(m, :missing, "default")     # "default"
Map.fetch(m, :name)                 # {:ok, "Alice"}
Map.fetch!(m, :name)                # "Alice"

# Modificação
Map.put(m, :email, "a@b.com")       # adiciona ou atualiza
Map.delete(m, :age)                 # remove
Map.update!(m, :age, &(&1 + 1))     # atualiza (falha se ausente)
Map.update(m, :age, 0, &(&1 + 1))   # atualiza com default
Map.merge(m, %{age: 31, role: :admin})
%{m | age: 31}                      # atualiza — falha se chave ausente

# Consulta
Map.has_key?(m, :name)    # true
Map.keys(m)               # [:age, :name]
Map.values(m)             # [30, "Alice"]
map_size(m)               # 2
```

### Keyword List

```elixir
opts = [timeout: 5_000, retry: 3]

opts[:timeout]                        # 5000
Keyword.get(opts, :retry)             # 3
Keyword.get(opts, :missing, :default) # :default
Keyword.put(opts, :debug, true)
Keyword.delete(opts, :retry)
Keyword.merge(opts, [timeout: 10_000])

# Sintaxe especial no final de chamadas
String.split("a b c", " ", trim: true, parts: 2)
```

### MapSet

```elixir
s1 = MapSet.new([1, 2, 3])
s2 = MapSet.new([3, 4, 5])

MapSet.member?(s1, 2)         # true
MapSet.put(s1, 4)             # #MapSet<[1, 2, 3, 4]>
MapSet.delete(s1, 2)          # #MapSet<[1, 3]>
MapSet.union(s1, s2)          # #MapSet<[1, 2, 3, 4, 5]>
MapSet.intersection(s1, s2)   # #MapSet<[3]>
MapSet.difference(s1, s2)     # #MapSet<[1, 2]>
MapSet.size(s1)               # 3
```

---

## 8. Enum

```elixir
# Transformação
Enum.map([1,2,3], &(&1 * 2))                    # [2, 4, 6]
Enum.flat_map([[1,2],[3,4]], & &1)               # [1, 2, 3, 4]

# Filtro
Enum.filter([1,2,3,4], &(rem(&1, 2) == 0))      # [2, 4]
Enum.reject([1,2,3,4], &(rem(&1, 2) == 0))      # [1, 3]
Enum.take_while([1,2,3,4], &(&1 < 3))           # [1, 2]
Enum.drop_while([1,2,3,4], &(&1 < 3))           # [3, 4]

# Redução
Enum.reduce([1,2,3], 0, fn x, acc -> acc + x end)  # 6
Enum.sum([1,2,3])          # 6
Enum.product([1,2,3,4])    # 24

# Busca
Enum.find([1,2,3], &(&1 > 1))          # 2
Enum.find_index([1,2,3], &(&1 > 1))    # 1

# Predicados
Enum.all?([2,4,6], &(rem(&1, 2) == 0))  # true
Enum.any?([1,2,3], &(&1 > 2))           # true
Enum.empty?([])                          # true
Enum.member?([1,2,3], 2)                # true

# Contagem
Enum.count([1,2,3])                     # 3
Enum.count([1,2,3], &(&1 > 1))          # 2
Enum.frequencies([1,1,2,2,3])           # %{1 => 2, 2 => 2, 3 => 1}

# Ordenação
Enum.sort([3,1,2])                      # [1, 2, 3]
Enum.sort([3,1,2], :desc)               # [3, 2, 1]
Enum.sort_by(users, & &1.name)
Enum.sort_by(users, & &1.age, :desc)
Enum.min([3,1,2])                       # 1
Enum.max([3,1,2])                       # 3
Enum.min_max([3,1,2])                   # {1, 3}

# Agrupamento
Enum.group_by([1,2,3,4], &(rem(&1, 2) == 0))
# %{false => [1, 3], true => [2, 4]}
Enum.chunk_every([1,2,3,4,5,6], 2)
# [[1,2], [3,4], [5,6]]
Enum.chunk_by([1,1,2,2,3], & &1)
# [[1,1], [2,2], [3]]

# Slice
Enum.take([1,2,3,4,5], 3)              # [1, 2, 3]
Enum.drop([1,2,3,4,5], 3)              # [4, 5]
Enum.slice([1,2,3,4,5], 1, 3)          # [2, 3, 4]
Enum.split([1,2,3,4,5], 3)             # {[1,2,3], [4,5]}

# Combinação
Enum.zip([1,2,3], [:a, :b, :c])        # [{1,:a}, {2,:b}, {3,:c}]
Enum.zip_with([1,2], [3,4], &(&1+&2))  # [4, 6]
Enum.uniq([1,1,2,2,3])                 # [1, 2, 3]
Enum.dedup([1,1,2,2,3])                # [1, 2, 3]  (só adjacentes)

# Conversão
Enum.join([1,2,3], ", ")               # "1, 2, 3"
Enum.into([a: 1, b: 2], %{})          # %{a: 1, b: 2}
Enum.to_list(1..5)                     # [1, 2, 3, 4, 5]

# Avançados
Enum.scan([1,2,3,4], 0, &(&1+&2))     # [1, 3, 6, 10]
Enum.with_index([10,20,30])            # [{10,0}, {20,1}, {30,2}]
Enum.with_index([10,20,30], 1)         # [{10,1}, {20,2}, {30,3}]
Enum.map_reduce([1,2,3], 0, fn x, acc ->
  {x * 2, acc + x}
end)                                   # {[2,4,6], 6}
Enum.random([1,2,3])                   # aleatório
Enum.shuffle([1,2,3])                  # aleatório
```

---

## 9. Stream

Lazy: processa elemento por elemento sem materializar listas intermediárias.
Ideal para grandes coleções e I/O.

```elixir
# Lazy pipeline — processa só o necessário
1..1_000_000
|> Stream.map(&(&1 * 2))
|> Stream.filter(&(rem(&1, 3) == 0))
|> Enum.take(5)
# [6, 12, 18, 24, 30]

# Leitura de arquivo sem carregar tudo na memória
File.stream!("grande.csv")
|> Stream.map(&String.trim/1)
|> Stream.reject(&(&1 == ""))
|> Enum.to_list()

# Sequências infinitas com unfold
fibs = Stream.unfold({0, 1}, fn {a, b} -> {a, {b, a + b}} end)
Enum.take(fibs, 8)
# [0, 1, 1, 2, 3, 5, 8, 13]

Stream.iterate(1, &(&1 * 2)) |> Enum.take(8)
# [1, 2, 4, 8, 16, 32, 64, 128]

Stream.cycle([:a, :b, :c]) |> Enum.take(7)
# [:a, :b, :c, :a, :b, :c, :a]

# Stream.resource — fonte com setup/cleanup garantido
Stream.resource(
  fn -> File.open!("file.txt") end,
  fn file ->
    case IO.read(file, :line) do
      :eof  -> {:halt, file}
      line  -> {[line], file}
    end
  end,
  fn file -> File.close(file) end
)
```

---

## 10. Recursão

```elixir
defmodule MyList do
  # Simples (stack overflow em listas grandes)
  def sum([]),      do: 0
  def sum([h | t]), do: h + sum(t)

  # Tail-recursive com acumulador (preferida)
  def sum(list, acc \ 0)
  def sum([], acc),      do: acc
  def sum([h | t], acc), do: sum(t, acc + h)

  # Map
  def map([], _f),     do: []
  def map([h | t], f), do: [f.(h) | map(t, f)]

  # Reverse (tail-recursive)
  def reverse(list, acc \ [])
  def reverse([], acc),      do: acc
  def reverse([h | t], acc), do: reverse(t, [h | acc])

  # Flatten
  def flatten([]),                          do: []
  def flatten([h | t]) when is_list(h),    do: flatten(h) ++ flatten(t)
  def flatten([h | t]),                    do: [h | flatten(t)]
end
```

---

## 11. Pipe Operator

```elixir
# Sem pipe (difícil de ler)
Enum.join(Enum.map(String.split("hello world", " "), &String.upcase/1), "-")

# Com pipe
"hello world"
|> String.split(" ")
|> Enum.map(&String.upcase/1)
|> Enum.join("-")
# "HELLO-WORLD"

# O resultado vai como PRIMEIRO argumento da próxima chamada
# Para casos especiais use then/1:
result
|> Enum.map(&transform/1)
|> then(fn list -> Enum.zip(list, ids) end)
|> dbg()   # inspeciona com contexto (Elixir 1.14+)
```

---

## 12. Comprehensions

```elixir
for x <- [1,2,3], do: x * 2
# [2, 4, 6]

# Produto cartesiano
for x <- [1,2], y <- [:a, :b], do: {x, y}
# [{1,:a}, {1,:b}, {2,:a}, {2,:b}]

# Com filtro
for x <- 1..10, rem(x, 2) == 0, do: x
# [2, 4, 6, 8, 10]

# Pattern matching (falhas ignoradas)
for {:ok, val} <- [{:ok, 1}, {:error, 2}, {:ok, 3}], do: val
# [1, 3]

# :into
for {k, v} <- [a: 1, b: 2], into: %{}, do: {k, v * 10}
# %{a: 10, b: 20}

# :uniq
for x <- [1,1,2,2,3], uniq: true, do: x
# [1, 2, 3]
```

---

## 13. Sigils

```elixir
~r/hello/i          # Regex (case-insensitive)
~s(it's "fine")     # String (sem escapar aspas)
~w(foo bar baz)     # Lista de strings: ["foo", "bar", "baz"]
~w(foo bar baz)a    # Lista de atoms:  [:foo, :bar, :baz]
~D[2024-01-15]      # Date
~T[10:30:00]        # Time
~N[2024-01-15 10:30:00]    # NaiveDateTime
~U[2024-01-15 10:30:00Z]   # DateTime (UTC)
~c(hello)           # Charlist

# Delimitadores aceitos: / | " ' { } [ ] ( ) < >
```

---

## 14. Structs

Mapas com chaves e tipos definidos em compile-time.

```elixir
defmodule User do
  @enforce_keys [:id, :email]
  defstruct [
    :id,
    :email,
    name: "Anonymous",
    role: :viewer,
    active: true
  ]

  @type t :: %__MODULE__{
    id: pos_integer(),
    email: String.t(),
    name: String.t(),
    role: atom(),
    active: boolean()
  }
end

user = %User{id: 1, email: "alice@example.com"}
user = %User{id: 1, email: "a@b.com", name: "Alice", role: :admin}

# Acesso
user.name                    # "Alice"

# Atualização
%{user | name: "Bob"}        # falha se campo não existir

# Pattern matching
def greet(%User{name: name, active: true}), do: "Olá, #{name}"
def greet(%User{active: false}),            do: "Usuário inativo"

# Verificação
is_struct(user)          # true
is_struct(user, User)    # true
```

---

## 15. Error Handling

```elixir
# Convenção {:ok, value} / {:error, reason}
case fetch_data(id) do
  {:ok, data}      -> process(data)
  {:error, reason} -> log_and_default(reason)
end

# Funções com ! levantam em vez de retornar {:error}
File.read!("config.json")   # levanta File.Error se ausente
Jason.decode!("{}")         # levanta se JSON inválido

# raise / rescue
try do
  raise ArgumentError, message: "valor inválido"
rescue
  e in ArgumentError -> {:error, e.message}
  e in [RuntimeError, KeyError] -> {:error, inspect(e)}
  _ -> {:error, :unknown}
after
  cleanup()   # sempre executa
end

# Filosofia OTP: prefira deixar processos falharem e o Supervisor reiniciar
# Use try/rescue apenas em boundaries de sistema (ex: plugs, controllers)
```
