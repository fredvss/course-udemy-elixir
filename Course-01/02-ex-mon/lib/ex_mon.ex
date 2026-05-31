defmodule ExMon do

  alias ExMon.Game.Actions

  @computer_name "Robotinik"
  @computer_moves [:move_avg, :move_rnd, :move_heal]

  alias ExMon.Player
  alias ExMon.Game
  alias ExMon.Game.Status
  alias alias ExMon.Game.Actions

  def create_player(name, move_rnd, move_avg, move_heal) do
    Player.build(name, move_rnd, move_avg, move_heal)
  end

  def start_game(player) do
    @computer_name
    |> create_player(:punch, :kick, :heal)
    |> Game.start(player)

    Status.print_round_message(Game.info())
  end

  def make_move(move) do

    Game.info()
    |> Map.get(:status)
    |> handle_status(move)

    computer_move(Game.info())
    Status.print_round_message(Game.info())
  end

  defp handle_status(:game_over, _move), do: Status.print_round_message(Game.info())

  defp handle_status(_other, move) do
    move
    |> Actions.fetch_move()
    |> Actions.do_move()
  end

  defp computer_move(%{turn: :computer, status: :continue}) do
    move = {:ok, Enum.random(@computer_moves)}
    Actions.do_move(move)
  end

  defp computer_move(_), do: :ok
end
