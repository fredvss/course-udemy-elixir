defmodule PatternMatching.Exercises do
  @moduledoc """
  Exercícios de pattern matching, cláusulas de função e guards.
  """

  @doc """
  Classifica o resultado de uma operação.

  ## Examples

      iex> PatternMatching.Exercises.classify({:ok, 42})
      :success

      iex> PatternMatching.Exercises.classify({:error, :not_found})
      :failure

      iex> PatternMatching.Exercises.classify(:unknown)
      :unknown
  """
  def classify({:ok, _}), do: :success
  def classify({:error, _}), do: :failure
  def classify(_), do: :unknown

  @doc """
  Retorna o primeiro elemento de uma lista não vazia.

  ## Examples

      iex> PatternMatching.Exercises.head([1, 2, 3])
      1
  """
  def head([first | _rest]), do: first

  @doc """
  Descreve um número inteiro usando guards.

  ## Examples

      iex> PatternMatching.Exercises.describe_number(5)
      :positive

      iex> PatternMatching.Exercises.describe_number(0)
      :zero

      iex> PatternMatching.Exercises.describe_number(-3)
      :negative
  """
  def describe_number(n) when n > 0, do: :positive
  def describe_number(0), do: :zero
  def describe_number(n) when n < 0, do: :negative

  @doc """
  Converte uma string em inteiro.

  ## Examples

      iex> PatternMatching.Exercises.parse_int("42")
      {:ok, 42}

      iex> PatternMatching.Exercises.parse_int("abc")
      {:error, :invalid}
  """
  def parse_int(string) when is_binary(string) do
    case Integer.parse(string) do
      {int, ""} -> {:ok, int}
      _ -> {:error, :invalid}
    end
  end

  @doc """
  Extrai nome e idade de um mapa de usuário.

  ## Examples

      iex> PatternMatching.Exercises.user_info(%{name: "Ana", age: 30})
      {:ok, "Ana", 30}

      iex> PatternMatching.Exercises.user_info(%{name: "Bob"})
      {:error, :missing_age}
  """
  def user_info(%{name: name, age: age}) when is_integer(age) and age >= 0 do
    {:ok, name, age}
  end

  def user_info(%{name: _name}) do
    {:error, :missing_age}
  end

  def user_info(_), do: {:error, :invalid_user}
end
