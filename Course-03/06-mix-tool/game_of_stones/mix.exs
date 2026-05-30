defmodule GameOfStones.MixProject do
  use Mix.Project

  def project do
    [
      app: :game_of_stones,
      version: "0.1.0",
      elixir: "~> 1.17",
      escript: [main_module: GameOfStones],
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [extra_applications: [:logger, :bunt]]
  end

  defp deps do
    [
      {:bunt, "~> 1.0"}
    ]
  end
end
