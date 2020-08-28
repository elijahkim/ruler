defmodule Ruler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Ruler.Repo,
      # Start the Telemetry supervisor
      RulerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Ruler.PubSub},
      # Start the Endpoint (http/https)
      RulerWeb.Endpoint
      # Start a worker by calling: Ruler.Worker.start_link(arg)
      # {Ruler.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ruler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RulerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
