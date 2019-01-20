# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chatplayer,
  ecto_repos: [Chatplayer.Repo]

# Configures the endpoint
config :chatplayer, ChatplayerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qetTaxL9Z3FGBJVfAhObhuCWeoMbjM0/8hOrDWyLvxgNdxnRb8bTEGjZ4h3Epi6K",
  render_errors: [view: ChatplayerWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Chatplayer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :chatplayer, Chatplayer.UserManager.Guardian,
  issuer: "auth_me",
  secret_key: "IKbjsCqQBw0OkdZKTYIyDRFtHoVZKq/XkgeYU8SaSUGG+PBY8bMXWt9Wd/JuSt1T" # put the result of the mix command above here

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
