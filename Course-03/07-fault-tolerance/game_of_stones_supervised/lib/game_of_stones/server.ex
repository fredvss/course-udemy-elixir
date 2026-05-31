defmodule GameOfStones.Server do
  use GenServer, restart: :transient # Reinicia apenas se o processo terminar com falha, não para :normal (fim de jogo)

  @server_name __MODULE__
  @not_enough_stones_error "Not enough stones. You can take between 1 and 3, and not more than what's available."

  # Public API

  def start_link(_) do
    # :started
    # :game_in_progress
    # :game_ended
    IO.puts("Starting Game of Stones Server...")
    GenServer.start_link(@server_name, :started, name: @server_name)
  end

  def set_stones(num_stones) do
    GenServer.call(@server_name, {:set_stones, num_stones})
  end

  def take(num_stones) do
    GenServer.call(@server_name, {:take, num_stones})
  end

  # Callbacks

  def init(:started) do
    {:ok, {1, 0, :started}}
  end

  def handle_call({:set_stones, num_stones}, _from, {player, _current_stones, :started}) do
    {:reply, {player, num_stones}, {player, num_stones, :game_in_progress}}
  end

  def handle_call({:take, num_stones}, _from, {player, current_stones, :game_in_progress}) do
    do_take(player, num_stones, current_stones)
  end

  # Private functions

  defp do_take(player, num_stones, current_stones)
       when not is_integer(num_stones)
       when num_stones < 1
       when num_stones > 3
       when num_stones > current_stones do
    {:reply, {:error, @not_enough_stones_error}, {player, current_stones, :game_in_progress}}
  end

  defp do_take(player, num_stones, current_stones) when num_stones == current_stones do
    {:stop, :normal, {:winner, next_player(player)}, {nil, 0, :game_ended}}
  end

  defp do_take(player, num_stones, current_stones) do
    next = next_player(player)
    new_stones = current_stones - num_stones
    {:reply, {:next_turn, next, new_stones}, {next, new_stones, :game_in_progress}}
  end

  defp next_player(1), do: 2
  defp next_player(2), do: 1
end
