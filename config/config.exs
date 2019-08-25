# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :voting,
  ecto_repos: [Voting.Repo]

# Configures the endpoint
config :voting, VotingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "o+St8AmFB5ZW+f51Ywnu5V5nH1gaywjPr6E+Wh1q6T65E2JGdNVr/HU4ev3gEVAL",
  render_errors: [view: VotingWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Voting.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :ueberauth, Ueberauth,
  providers: [
    facebook: { Ueberauth.Strategy.Facebook, [] }
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "539430019929610",
  client_secret: "754246b9792708d38770baaf24dcbe00",
  redirect_uri: "http://localhost:4000/auth/facebook/callback"

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_APP_ID"),
  client_secret: System.get_env("FACEBOOK_APP_SECRET"),
  redirect_uri: "http://localhost:4000/auth/facebook/callback"

config :voting, Voting.Account.Guardian,
  issuer: "voting",
  secret_key: "Nwf//bjBd8wwkhlcNag286LUyTVNv3khmGWWUbGEIp6vKP6v/DS40S+4hY1YzlHZ" # put the result of the mix command above here

#import_config "config.secret.exs"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

