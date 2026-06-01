defmodule Storage do
  @name {:global, :storage}

  def start_link do
    Agent.start_link(fn -> %{} end, name: @name)
  end

  def put(result, number) do
    Agent.update(@name, fn state -> Map.merge(state, %{number => result}) end)
  end

  def factorials do
    Agent.get(@name, &(&1))
  end

  def factorial_of(number) do
    Agent.get(@name, &(&1[number]))
  end
end


defmodule FactorialProducer do
  def products_of(numbers) do
    numbers
    |> Stream.map(fn number -> Task.async(fn -> factorial(number) end) end)
    |> Enum.map(&Task.await/1)
  end

  def factorial(number) do
    do_factorial(1, number) |> Storage.put(number)
  end

  defp do_factorial(result, 0), do: result

  defp do_factorial(result, number), do: do_factorial(result * number, number - 1)
end

# Storage.start_link()
# FactorialProducer.products_of(1..10)

# Storage.factorials()    |> IO.inspect
# Storage.factorial_of(5) |> IO.inspect
