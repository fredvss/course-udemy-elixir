defmodule Mix.Tasks.Greet do
  @moduledoc """
  Saudação personalizada com argumentos.

      mix greet Elixir
      mix greet --upper elixir
  """
  use Mix.Task

  @shortdoc "Sauda um nome passado como argumento"

  @impl Mix.Task
  def run(args) do
    {opts, rest, _} = OptionParser.parse(args, strict: [upper: :boolean])

    case rest do
      [] ->
        Mix.shell().error("Uso: mix greet NOME [--upper]")

      [name | _] ->
        message = MixTasks.Greeter.message(name)

        output =
          if opts[:upper], do: String.upcase(message), else: message

        Mix.shell().info(output)
    end
  end
end
