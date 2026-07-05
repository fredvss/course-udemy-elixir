defmodule MixHello do
  @moduledoc """
  Primeiro módulo Mix com documentação e doctests.

  Demonstra `@moduledoc`, `@doc` e exemplos executáveis nos testes.
  """

  @doc """
  Retorna uma saudação personalizada.

  ## Examples

      iex> MixHello.greet("Elixir")
      "Olá, Elixir!"

      iex> MixHello.greet()
      "Olá, mundo!"
  """
  def greet(name \\ "mundo") do
    "Olá, #{name}!"
  end

  @doc """
  Soma dois inteiros.

  ## Examples

      iex> MixHello.add(2, 3)
      5

      iex> MixHello.add(-1, 1)
      0
  """
  def add(a, b), do: a + b

  @doc """
  Verifica se um número é par.

  ## Examples

      iex> MixHello.even?(4)
      true

      iex> MixHello.even?(7)
      false
  """
  def even?(n), do: rem(n, 2) == 0
end
