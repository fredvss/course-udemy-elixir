defmodule ExMon.Game.Actions do

  alias ExMon.Game
  alias ExMon.Game.Status
  alias Game.Actions.Attack
  alias Game.Actions.Heal

  def fetch_move(move) do
    Game.player()
    |> Map.get(:moves)
    |> find_move(move)
  end

  defp find_move(moves, move) do
    Enum.find_value(moves, {:error, move}, fn {key, value} ->
      if value == move, do: {:ok, key}
    end)
  end

  def do_move({:error, move}), do: Status.print_wrong_move_message(move)

  def do_move({:ok, move}) do
    case move do
      :move_heal -> heal()
      move -> attack(move)
    end
  end

  defp attack(move) do
    case Game.turn() do
      :player -> Attack.attack_opponent(:computer, move)
      :computer -> Attack.attack_opponent(:player, move)
    end
  end

  defp heal() do
    case Game.turn() do
      :player -> Heal.heal_life(:player)
      :computer -> Heal.heal_life(:computer)
    end
  end
end
