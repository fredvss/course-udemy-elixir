defmodule Demo do
  use GenServer

  def init(initial_state) do
    "I am started with the state: #{initial_state}" |> IO.puts()
    {:ok, initial_state}
  end
end

GenServer.start(Demo, "Hello World") |> IO.inspect()
