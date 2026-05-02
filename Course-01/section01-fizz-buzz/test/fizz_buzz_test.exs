defmodule FizzBuzzTest do
  use ExUnit.Case
  doctest FizzBuzz

  describe "build/1" do
    test "when a valid file is provided, returns  the converted list" do
      expected_response = {:ok, [1, 2, :fizz, 4, :buzz, 8, :fizz, :fizzbuzz, :buzz, :fizzbuzz]}

      assert FizzBuzz.build("numbers.txt") == expected_response
    end

    test "when an invalid file is provided, returns  an error messsage" do
      expected_response = {:error, "Error reading the file: enoent"}

      assert FizzBuzz.build("invalid.txt") == expected_response
    end
  end
end
