import Config

config :ethereumex,
  http_options: [pool_timeout: 5000, receive_timeout: 15_000],
  http_pool_options: %{},
  http_headers: [],
  json_module: Jason,
  enable_request_error_logs: false

# config :ethereumex, ipc_path: "/Library/Application Support/io.parity.ethereum/jsonrpc.ipc"
import_config "#{Mix.env()}.exs"
