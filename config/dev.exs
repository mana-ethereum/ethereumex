use Mix.Config
config :ethereumex,
  url: System.get_env("ETHEREUM_URL"),
  scheme: System.get_env("ETHEREUM_SCHEME"),
  host: System.get_env("ETHEREUM_HOST"),
  port: System.get_env("ETHEREUM_PORT")
