defmodule MixTasks.MixProject do
  use Mix.Project

  def project do
    [
      app: :mix_tasks,
      version: "0.1.0",
      elixir: "~> 1.19",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {MixTasks.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
