# Pipe operator |>
# Execute: elixir 03_pipe.exs

IO.puts("=== Sem pipe (leitura de dentro para fora) ===")
result_without_pipe =
  Enum.sum(Enum.map(Enum.filter(1..10, fn n -> rem(n, 2) == 0 end), fn n -> n * n end))

IO.inspect(result_without_pipe, label: "soma dos quadrados dos pares")

IO.puts("\n=== Com pipe (leitura de cima para baixo) ===")
result_with_pipe =
  1..10
  |> Enum.filter(fn n -> rem(n, 2) == 0 end)
  |> Enum.map(fn n -> n * n end)
  |> Enum.sum()

IO.inspect(result_with_pipe, label: "mesmo resultado")

IO.puts("\n=== Pipe com funções capturadas ===")
words = ["elixir", "phoenix", "ecto"]

uppercased =
  words
  |> Enum.map(&String.upcase/1)
  |> Enum.join(", ")

IO.inspect(uppercased)
