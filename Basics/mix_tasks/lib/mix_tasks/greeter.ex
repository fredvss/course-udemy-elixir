defmodule MixTasks.Greeter do
  @moduledoc """
  Lógica reutilizada pelas tarefas Mix do projeto.
  """

  @doc """
  Formata uma saudação para o nome informado.

  ## Examples

      iex> MixTasks.Greeter.message("Elixir")
      "Olá, Elixir! Bem-vindo ao Mix."
  """
  def message(name) when is_binary(name) do
    "Olá, #{name}! Bem-vindo ao Mix."
  end
end
