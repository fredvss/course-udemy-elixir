defmodule Calculator do
  use GenServer

  # Starts the GenServer
  def start(initial_state) do
    GenServer.start(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(initial_state) when is_number(initial_state) do
    "I am started with the state #{initial_state}" |> IO.puts
    {:ok, initial_state}
  end

  def init(_) do
    {:stop, "The initial state is not a number :("}
  end

  # Public API
  def add(number) do
    GenServer.cast(__MODULE__, {:add, number})
  end

  def sub(number) do
    GenServer.cast(__MODULE__, {:sub, number})
  end

  def sqrt do
    GenServer.cast(__MODULE__, :sqrt)
  end

  def result do
    GenServer.call(__MODULE__, :result, 5000)
  end

  # Synchronous request
  def handle_call(:result, _,  current_state) do
    {:reply, current_state, current_state}
  end

  def terminate(reason, current_state) do
    IO.puts "Terminating with reason: #{inspect(reason)} and state: #{inspect(current_state)}"
  end

  # Asynchronous request
  def handle_cast(:sqrt, current_state) do
    {:noreply, :math.sqrt(current_state)}
  end

  def handle_cast({:add, number}, current_state) do
    {:noreply, current_state + number}
  end

  def handle_cast({:sub, number}, current_state) do
    {:noreply, current_state - number}
  end
end


{:ok, _pid} = Calculator.start(4)

Calculator.add(10)
Calculator.result |> IO.inspect

Calculator.sub(5)
Calculator.result |> IO.inspect

Calculator.sqrt()
Calculator.result |> IO.inspect
