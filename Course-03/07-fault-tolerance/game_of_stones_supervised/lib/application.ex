defmodule GameOfStones.Application do
  use Application

  def start(_type, _args) do
    # Define the child processes to be supervised
    children = [
      GameOfStones.Server
    ]

    opts = [strategy: :one_for_one, name: GameOfStones.Supervisor]

    Supervisor.start_link(children, opts) # Start the supervisor with the defined children and options
  end
end
