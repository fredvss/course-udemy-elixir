defmodule GameOfStones.Client do
  def play(num_stones \\ 30) do
    GameOfStones.Server.start(num_stones)
    start_game!()
  end

  defp start_game!() do
    case GameOfStones.Server.stats() do
      {player, stones} ->
        max_take = min(3, stones)
        IO.puts("Player #{player}'s turn. There are #{stones} stones left.")
        num_to_take = get_num_to_take(max_take)
        case GameOfStones.Server.take(num_to_take) do
          {:next_turn, _next_player, new_stones} ->
            IO.puts("Player #{player} took #{num_to_take} stone(s). #{new_stones} stones left.")
            start_game!()

          {:winner, winner} ->
            IO.puts("Player #{player} took the last stone. Player #{winner} wins!")

          {:error, error_message} ->
            IO.puts("Error: #{error_message}")
            start_game!()
        end

      _ ->
        IO.puts("Unexpected game state.")
    end
  end

  defp get_num_to_take(max_take) do
    case IO.gets("Enter number of stones to take (1-#{max_take}): ") |> String.trim() |> Integer.parse() do
      {n, ""} -> n
      _ ->
        IO.puts("Invalid input. Please enter a whole number.")
        get_num_to_take(max_take)
    end
  end
end

defmodule GameOfStones.Server do
  use GenServer

  @initial_stones_default 30
  @server_name __MODULE__
  @not_enough_stones_error "Not enough stones to take. You can take between 1 and 3 stones, and not more than the current number of stones."

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

  def handle_call(:stats, _from, current_stones) do
    {:reply, current_stones, current_stones}
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

GameOfStones.Client.play()
