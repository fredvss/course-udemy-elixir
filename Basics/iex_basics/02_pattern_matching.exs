# Pattern matching
# Execute: elixir 02_pattern_matching.exs

IO.puts("=== Atribuição e matching ===")
{x, y} = {1, 2}
IO.inspect({x, y}, label: "tupla desestruturada")

IO.puts("\n=== Ignorar valores com _ ===")
{status, _payload} = {:ok, %{id: 1}}
IO.inspect(status)

IO.puts("\n=== Pin operator ^ ===")
a = 1
^a = 1
IO.puts("pin com mesmo valor: ok")

IO.puts("\n=== Matching em listas ===")
[first, second | rest] = [10, 20, 30, 40]
IO.inspect({first, second, rest})

IO.puts("\n=== Matching em mapas ===")
%{name: nome, age: idade} = %{name: "Bob", age: 25, city: "SP"}
IO.inspect({nome, idade})

IO.puts("\n=== Tuplas {:ok, _} e {:error, _} ===")
case File.read(__ENV__.file) do
  {:ok, content} ->
  IO.inspect(String.length(content), label: "bytes lidos de #{Path.basename(__ENV__.file)}")

  {:error, reason} ->
    IO.inspect(reason, label: "erro")
end
