defmodule GameOfStones.Client do
  def play(num_stones \\ 30) do
    case GameOfStones.Server.set_stones(num_stones) do
      {player, stones, :game_in_progress} ->
        game_loop(player, stones)

      {player, stones, :game_continue} ->
        IO.puts("Resuming game with Player #{player} and #{stones} stones left.")
        game_loop(player, stones)

      _ ->
        [:red, "Unexpected game state."] |> Bunt.puts()
    end
  end

  defp game_loop(player, stones) do
    max_take = min(3, stones)
    (player_color(player) ++ ["Player #{player}'s turn. There are #{stones} stones left."]) |> Bunt.puts()
    num_to_take = get_num_to_take(max_take)

    case GameOfStones.Server.take(num_to_take) do
      {:next_turn, next_player, new_stones} ->
        IO.puts("Player #{player} took #{num_to_take} stone(s). #{new_stones} stones left.")
        game_loop(next_player, new_stones)

      {:winner, winner} ->
        [:green, :bright, "Player #{player} took the last stone. Player #{winner} wins!"] |> Bunt.puts()

      {:error, error_message} ->
        [:red, "Error: #{error_message}"] |> Bunt.puts()
        game_loop(player, stones)
    end
  end

  defp get_num_to_take(max_take) do
    case IO.gets("Enter number of stones to take (1-#{max_take}): ")
         |> String.trim()
         |> Integer.parse() do
      {n, ""} ->
        n

      _ ->
        [:red, "Invalid input. Please enter a whole number."] |> Bunt.puts()
        get_num_to_take(max_take)
    end
  end

  defp player_color(1), do: [:cyan]
  defp player_color(2), do: [:yellow]
  defp player_color(_), do: []
end
