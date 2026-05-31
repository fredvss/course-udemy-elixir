defmodule Demo do
  use GenServer

  def start(initial_state) do
    GenServer.start(__MODULE__, initial_state)
  end

  def init(initial_state) when is_binary(initial_state) do
    "I am started with the state: #{initial_state}" |> IO.puts()
    {:ok, initial_state}
  end

  def init(initial_state) do
    {:stop, "I can only be started with a string, but I got: #{inspect(initial_state)}"}
  end
end

Demo.start("Teste") |> IO.inspect()
