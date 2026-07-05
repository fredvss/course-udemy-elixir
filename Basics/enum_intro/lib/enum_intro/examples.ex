defmodule EnumIntro.Examples do
  @moduledoc """
  Exemplos de `Enum` e list comprehensions para transformar coleções.
  """

  @doc """
  Dobra cada número da lista.

  ## Examples

      iex> EnumIntro.Examples.double([1, 2, 3])
      [2, 4, 6]
  """
  def double(numbers) do
    Enum.map(numbers, fn n -> n * 2 end)
  end

  @doc """
  Mantém apenas números pares.

  ## Examples

      iex> EnumIntro.Examples.evens([1, 2, 3, 4, 5])
      [2, 4]
  """
  def evens(numbers) do
    Enum.filter(numbers, &(rem(&1, 2) == 0))
  end

  @doc """
  Soma todos os elementos.

  ## Examples

      iex> EnumIntro.Examples.sum([1, 2, 3, 4])
      10
  """
  def sum(numbers) do
    Enum.reduce(numbers, 0, &+/2)
  end

  @doc """
  Conta quantos elementos satisfazem o predicado.

  ## Examples

      iex> EnumIntro.Examples.count_greater_than([1, 5, 3, 8], 3)
      2
  """
  def count_greater_than(numbers, threshold) do
    numbers
    |> Enum.count(&(&1 > threshold))
  end

  @doc """
  Agrupa palavras por tamanho.

  ## Examples

      iex> EnumIntro.Examples.group_by_length(["elixir", "ex", "phoenix"])
      %{2 => ["ex"], 6 => ["elixir"], 7 => ["phoenix"]}
  """
  def group_by_length(words) do
    Enum.group_by(words, &String.length/1)
  end

  @doc """
  Retorna os quadrados dos números pares usando comprehension.

  ## Examples

      iex> EnumIntro.Examples.square_evens(1..6)
      [4, 16, 36]
  """
  def square_evens(range) do
    for n <- range, rem(n, 2) == 0, do: n * n
  end

  @doc """
  Gera pares {letra, índice} com comprehension e filtro.

  ## Examples

      iex> EnumIntro.Examples.vowel_positions("elixir")
      [{"e", 0}, {"i", 2}, {"i", 4}]
  """
  def vowel_positions(word) do
    vowels = ~c"aeiou"

    for {char, index} <- Enum.with_index(String.to_charlist(word)),
        char in vowels,
        do: {<<char>>, index}
  end

  @doc """
  Pipeline completo: filtra, transforma e junta em string.

  ## Examples

      iex> scores = [45, 72, 33, 88, 51]
      iex> EnumIntro.Examples.format_scores(scores)
      "51, 72, 88"
  """
  def format_scores(scores) do
    scores
    |> Enum.filter(&(&1 >= 50))
    |> Enum.sort()
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join(", ")
  end
end
