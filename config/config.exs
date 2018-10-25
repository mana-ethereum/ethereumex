use Mix.Config

config :ethereumex, http_options: [timeout: 8000, recv_timeout: 5000]
# config :ethereumex, ipc_path: "/Library/Application Support/io.parity.ethereum/jsonrpc.ipc"
import_config "#{Mix.env()}.exs"
