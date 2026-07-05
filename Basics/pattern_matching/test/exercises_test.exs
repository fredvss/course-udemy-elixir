defmodule PatternMatching.ExercisesTest do
  use ExUnit.Case, async: true
  doctest PatternMatching.Exercises

  test "head/1 com lista de um elemento" do
    assert PatternMatching.Exercises.head([:only]) == :only
  end

  test "parse_int/1 rejeita strings com sufixo" do
    assert PatternMatching.Exercises.parse_int("42px") == {:error, :invalid}
  end
end
