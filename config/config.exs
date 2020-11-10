import Config

config :heron, Heron.Repo,
  #adapter: Ecto.Adapters.MyXQL,
  database: "heron",
  username: "heron",
  password: "Heron1882!",
  hostname: "localhost"

config :heron, ecto_repos: [Heron.Repo]

# Logging Configuration
config :heron, :logger,
  format: "[$level]: $message"


