# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config
alias Rule.Rules.{Rule, Command}

config :ruler,
  ecto_repos: [Ruler.Repo]

# Configures the endpoint
config :ruler, RulerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VjUXQDpJA9UufLkm3Pajk6TadHtB/RozWMTgp3f+aDRCWtLsx9zkYHWV48Kb0qOU",
  render_errors: [view: RulerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Ruler.PubSub,
  live_view: [signing_salt: "y5bu6yuA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ruler, Ruler.Repo, migration_primary_key: [name: :id, type: :binary_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
