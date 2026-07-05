defmodule Mix.Tasks.Hello do
  @moduledoc """
  Tarefa simples que imprime uma saudação.

      mix hello
  """
  use Mix.Task

  @shortdoc "Imprime uma saudação no terminal"

  @impl Mix.Task
  def run(_args) do
    Mix.shell().info("Olá do Mix.Task!")
    Mix.shell().info("Use `mix greet Nome` para uma saudação personalizada.")
  end
end
