import Config

config :ethereumex,
  http_options: [pool_timeout: 5000, receive_timeout: 15_000],
  http_pool_options: %{},
  http_headers: [{"Content-Type", "application/json"}]

# config :ethereumex, ipc_path: "/Library/Application Support/io.parity.ethereum/jsonrpc.ipc"
import_config "#{Mix.env()}.exs"
