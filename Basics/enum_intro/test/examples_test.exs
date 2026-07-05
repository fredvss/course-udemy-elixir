defmodule EnumIntro.ExamplesTest do
  use ExUnit.Case, async: true
  doctest EnumIntro.Examples

  test "pipeline com map e filter" do
    result =
      1..10
      |> Enum.filter(&(rem(&1, 2) == 0))
      |> Enum.map(&(&1 * &1))

    assert result == [4, 16, 36, 64, 100]
  end
end
