defmodule GameOfStones do
  def main(args) do
    num_stones = parse_args(args)
    GameOfStones.Client.play(num_stones)
  end

  defp parse_args([n | _]) do
    case Integer.parse(n) do
      {num, ""} when num > 0 -> num
      _ -> 30
    end
  end

  defp parse_args([]), do: 30
end
