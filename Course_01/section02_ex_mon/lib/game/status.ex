defmodule ExMon.Game.Status do

  def print_round_message(%{status: :started} = info) do
    IO.puts("\n====== The game has started ======\n")
    IO.inspect(info)
    IO.puts("----------------------------")
  end


  def print_round_message(%{status: :continue, turn: player} = info) do
    IO.puts("\n====== Its #{player} turn. ======\n")
    IO.inspect(info)
    IO.puts("----------------------------")
  end

    def print_round_message(%{status: :game_over} = info) do
    IO.puts("\n====== The game is over. ======\n")
    IO.inspect(info)
    IO.puts("----------------------------")
  end

  def print_wrong_move_message(move) do
    IO.puts("\n====== Invalid move: #{move} ======\n")
  end

  def print_move_message(:computer, :attack, damage), do: IO.puts("\n====== The player attacked the computer causing #{damage} damage ======\n")
  def print_move_message(:player, :attack, damage), do: IO.puts("\n====== The computer attacked the player causing #{damage} damage ======\n")

  def print_move_message(player, :heal, life), do: IO.puts("\n====== The #{player} healed itself - now has #{life} points ======\n")

end
