defmodule Mix.Tasks.Stats do
  @moduledoc """
  Calcula estatísticas simples de uma lista de números.

      mix stats 10 20 30 5
  """
  use Mix.Task

  @shortdoc "Mostra soma, média e máximo de números"

  @impl Mix.Task
  def run(args) do
    numbers =
      args
      |> Enum.map(&parse_number/1)
      |> Enum.reject(&is_nil/1)

    case numbers do
      [] ->
        Mix.shell().error("Uso: mix stats NUMERO [NUMERO ...]")

      nums ->
        sum = Enum.sum(nums)
        avg = sum / length(nums)
        max = Enum.max(nums)

        Mix.shell().info("Números: #{inspect(nums)}")
        Mix.shell().info("Soma:   #{sum}")
        Mix.shell().info("Média:  #{Float.round(avg, 2)}")
        Mix.shell().info("Máximo: #{max}")
    end
  end

  defp parse_number(arg) do
    case Integer.parse(arg) do
      {n, ""} -> n
      _ -> nil
    end
  end
end
