defmodule Calculator do
  use GenServer

  @process_name __MODULE__

  # Starts the GenServer
  def start(initial_state) do
    GenServer.start(@process_name, initial_state, name: @process_name)
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
    GenServer.cast(@process_name, {:add, number})
  end

  def sub(number) do
    GenServer.cast(@process_name, {:sub, number})
  end

  def sqrt do
    GenServer.cast(@process_name, :sqrt)
  end

  def result do
    GenServer.call(@process_name, :result, 5000)
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


Calculator.start(4) |> IO.inspect

Calculator.add(10)
Calculator.result |> IO.inspect

Calculator.sub(5)
Calculator.result |> IO.inspect

Calculator.sqrt()
Calculator.result |> IO.inspect
