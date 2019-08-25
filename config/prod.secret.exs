use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :voting, VotingWeb.Endpoint,
  secret_key_base: "KO6ECX+vRffo0ArrdQEvhkLDAtSd0ec60iahjHIxa4mxfRKdK/+b6bgF7ryTzNPv"

# Configure your database
config :voting, Voting.Repo,
  username: "postgres",
  password: "postgres",
  database: "voting_prod",
  pool_size: 15

config :voting, Voting.Repo,
  ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
