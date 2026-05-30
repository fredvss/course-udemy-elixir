defmodule GameOfStones.Server do
  use GenServer

  @initial_stones_default 30
  @server_name __MODULE__
  @not_enough_stones_error "Not enough stones. You can take between 1 and 3, and not more than what's available."

  # Public API

  def start(initial_stones \\ @initial_stones_default) do
    GenServer.start(@server_name, initial_stones, name: @server_name)
  end

  def stats do
    GenServer.call(@server_name, :stats)
  end

  def take(num_stones) do
    GenServer.call(@server_name, {:take, num_stones})
  end

  # Callbacks

  def init(initial_stones) when is_integer(initial_stones) do
    {:ok, {1, initial_stones}}
  end

  def handle_call(:stats, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:take, num_stones}, _from, {player, current_stones}) do
    do_take(player, num_stones, current_stones)
  end

  # Private functions

  defp do_take(player, num_stones, current_stones)
       when not is_integer(num_stones)
       when num_stones < 1
       when num_stones > 3
       when num_stones > current_stones do
    {:reply, {:error, @not_enough_stones_error}, {player, current_stones}}
  end

  defp do_take(player, num_stones, current_stones) when num_stones == current_stones do
    {:stop, :normal, {:winner, next_player(player)}, {nil, 0}}
  end

  defp do_take(player, num_stones, current_stones) do
    next = next_player(player)
    new_stones = current_stones - num_stones
    {:reply, {:next_turn, next, new_stones}, {next, new_stones}}
  end

  defp next_player(1), do: 2
  defp next_player(2), do: 1
end
