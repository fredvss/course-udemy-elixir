defmodule Teste do
  def division(_a, 0) do
    {:error, "Division by zero is not allowed"}
  end

  def division(a, b) do
    a / b
  end

  def factorial(0) do
    1
  end

  def factorial(value) do
    value * factorial(value - 1)
  end

  reverse_function = fn(word) ->
    String.reverse(word)
  end

  reverse_function.("Hello, World!") |> IO.puts()

  # Using capture operator
  reverse_function2 = &String.reverse/1

  reverse_function2.("Hello, Elixir!") |> IO.puts()

  # Anonymous function with multiple bodies

  multi_body_function = fn
    0 -> "Zero"
    1 -> "One"
    _ -> "Other"
  end

  IO.puts(multi_body_function.(0))  # Output: "Zero"
  IO.puts(multi_body_function.(1))  # Output: "One"
  IO.puts(multi_body_function.(5))  # Output: "Other"
end
