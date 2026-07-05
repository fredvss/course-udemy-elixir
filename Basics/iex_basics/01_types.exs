# Tipos nativos do Elixir
# Execute: elixir 01_types.exs

IO.puts("=== Integers ===")
IO.inspect(42)
IO.inspect(0b1010, label: "binário")
IO.inspect(1_000_000, label: "com separador")

IO.puts("\n=== Floats ===")
IO.inspect(3.14)
IO.inspect(1.0e-2, label: "notação científica")

IO.puts("\n=== Atoms ===")
IO.inspect(:ok)
IO.inspect(true)
IO.inspect(nil)

IO.puts("\n=== Strings ===")
name = "Elixir"
IO.inspect("Olá, #{name}!", label: "interpolação")
IO.inspect(String.upcase("hello"))

IO.puts("\n=== Lists ===")
IO.inspect([1, 2, 3])
IO.inspect([head | tail] = [1, 2, 3], label: "pattern match em lista")
IO.inspect({head, tail})

IO.puts("\n=== Tuples ===")
IO.inspect({:ok, 42})
IO.inspect(elem({:error, "falhou"}, 0))

IO.puts("\n=== Maps ===")
user = %{name: "Ana", age: 30}
IO.inspect(user)
IO.inspect(Map.get(user, :name))
