defmodule Ethereumex.Client.Macro do
  alias Ethereumex.Client.Server

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Ethereumex.Client.Behaviour

      def web3_client_version(opts \\ []) do
        "web3_clientVersion" |> request([], opts)
      end

      def web3_sha3(data, opts \\ []) do
        params = [data]

        "web3_sha3" |> request(params, opts)
      end

      def net_version(opts \\ []) do
        "net_version" |> request([], opts)
      end

      def net_peer_count(opts \\ []) do
        "net_peerCount" |> request([], opts)
      end

      def net_listening(opts \\ []) do
        "net_listening" |> request([], opts)
      end

      def eth_protocol_version(opts \\ []) do
        "eth_protocolVersion" |> request([], opts)
      end

      def eth_syncing(opts \\ []) do
        "eth_syncing" |> request([], opts)
      end

      def eth_coinbase(opts \\ []) do
        "eth_coinbase" |> request([], opts)
      end

      def eth_mining(opts \\ []) do
        "eth_mining" |> request([], opts)
      end

      def eth_hashrate(opts \\ []) do
        "eth_hashrate" |> request([], opts)
      end

      def eth_gas_price(opts \\ []) do
        "eth_gasPrice" |> request([], opts)
      end

      def eth_accounts(opts \\ []) do
        "eth_accounts" |> request([], opts)
      end

      def eth_block_number(opts \\ []) do
        "eth_blockNumber" |> request([], opts)
      end

      def eth_get_balance(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        "eth_getBalance" |> request(params, opts)
      end

      def eth_get_storage_at(address, position, block \\ "latest", opts \\ []) do
        params = [address, position, block]

        "eth_getStorageAt" |> request(params, opts)
      end

      def eth_get_transaction_count(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        "eth_getTransactionCount" |> request(params, opts)
      end

      def eth_get_block_transaction_count_by_hash(hash, opts \\ []) do
        params = [hash]

        "eth_getBlockTransactionCountByHash" |> request(params, opts)
      end

      def eth_get_block_transaction_count_by_number(block \\ "latest", opts \\ []) do
        params = [block]

        "eth_getBlockTransactionCountByNumber" |> request(params, opts)
      end

      def eth_get_uncle_count_by_block_hash(hash, opts \\ []) do
        params = [hash]

        "eth_getUncleCountByBlockHash" |> request(params, opts)
      end

      def eth_get_uncle_count_by_block_number(block \\ "latest", opts \\ []) do
        params = [block]

        "eth_getUncleCountByBlockNumber" |> request(params, opts)
      end

      def eth_get_code(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        "eth_getCode" |> request(params, opts)
      end

      def eth_sign(address, message, opts \\ []) do
        params = [address, message]

        "eth_sign" |> request(params, opts)
      end

      def eth_send_transaction(transaction, opts \\ []) do
        params = [transaction, opts]

        "eth_sendTransaction" |> request(params, opts)
      end

      def eth_send_raw_transaction(data, opts \\ []) do
        params = [data]

        "eth_sendRawTransaction" |> request(params, opts)
      end

      @spec add_request_info([binary] | [map], binary) :: map
      defp add_request_info(method_name, params \\ []) do
        %{}
        |> Map.put("method", method_name)
        |> Map.put("jsonrpc", "2.0")
        |> Map.put("params", params)
      end

      def request(name, params, [batch: true]) do
        name |> add_request_info(params)
      end

      def request(name, params, _) do
        name
        |> add_request_info(params)
        |> server_request
      end

      def batch_request(methods) do
        methods
        |> Enum.map(fn({method, params}) ->
          opts = [batch: true]
          params = params ++ [opts]

          apply(__MODULE__, method, params)
        end)
        |> server_request
      end

      @spec server_request(map) :: {:ok, map} | {:error, map} | {:error, atom}
      defp server_request(params) do
        GenServer.call __MODULE__, {:request, params}
      end

      def start_link do
        Server.start_link(__MODULE__)
      end

      def reset_id do
        GenServer.cast __MODULE__, :reset_id
      end

      def single_request(params) do
        {:error, :not_implemented}
      end

      defoverridable [single_request: 1]
    end
  end
end
