defmodule TestBank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TestBankWeb.Telemetry,
      TestBank.Repo,
      {DNSCluster, query: Application.get_env(:test_bank, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TestBank.PubSub},
      # Start a worker by calling: TestBank.Worker.start_link(arg)
      # {TestBank.Worker, arg},
      # Start to serve requests, typically the last entry
      TestBankWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TestBank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TestBankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
