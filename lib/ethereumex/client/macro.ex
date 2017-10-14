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

      def eth_estimate_gas(transaction, block \\ "latest", opts \\ []) do
        params = [transaction, block]

        "eth_estimateGas" |> request(params, opts)
      end

      def eth_get_block_by_hash(hash, full, opts \\ []) do
        params = [hash, full]

        "eth_getBlockByHash" |> request(params, opts)
      end

      def eth_get_block_by_number(number, full, opts \\ []) do
        params = [number, full]

        "eth_getBlockByNumber" |> request(params, opts)
      end

      def eth_get_transaction_by_hash(hash, opts \\ []) do
        params = [hash]

        "eth_getTransactionByHash" |> request(params, opts)
      end

      def eth_get_transaction_by_block_hash_and_index(hash, index, opts \\ []) do
        params = [hash, index]

        "eth_getTransactionByBlockHashAndIndex" |> request(params, opts)
      end

      def eth_get_transaction_by_block_number_and_index(block, index, opts \\ []) do
        params = [block, index]

        "eth_getTransactionByBlockNumberAndIndex" |> request(params, opts)
      end

      def eth_get_transaction_receipt(hash, opts \\ []) do
        params = [hash]

        "eth_getTransactionReceipt" |> request(params, opts)
      end

      def eth_get_uncle_by_block_hash_and_index(hash, index, opts \\ []) do
        params = [hash, index]

        "eth_getUncleByBlockHashAndIndex" |> request(params, opts)
      end

      def eth_get_uncle_by_block_number_and_index(block, index, opts \\ []) do
        params = [block, index]

        "eth_getUncleByBlockNumberAndIndex" |> request(params, opts)
      end

      def eth_get_compilers(opts \\ []) do
        "eth_getCompilers" |> request([], opts)
      end

      def eth_new_filter(data, opts \\ []) do
        params = [data]

        "eth_newFilter" |> request(params, opts)
      end

      def eth_new_block_filter(opts \\ []) do
        "eth_newBlockFilter" |> request([], opts)
      end

      def eth_new_pending_transaction_filter(opts \\ []) do
        "eth_newPendingTransactionFilter" |> request([], opts)
      end

      def eth_uninstall_filter(id, opts \\ []) do
        params = [id]

        "eth_uninstallFilter" |> request(params, opts)
      end

      def eth_get_filter_changes(id, opts \\ []) do
        params = [id]

        "eth_getFilterChanges" |> request(params, opts)
      end

      def eth_get_filter_logs(id, opts \\ []) do
        params = [id]

        "eth_getFilterLogs" |> request(params, opts)
      end

      def eth_get_logs(filter, opts \\ []) do
        params = [filter]

        "eth_getLogs" |> request(params, filter)
      end

      def eth_get_work(opts \\ []) do
        "eth_getWork" |> request([], opts)
      end

      def eth_submit_work(nonce, header, digest, opts \\ []) do
        params = [nonce, header, digest]

        "eth_submitWork" |> request(params, opts)
      end

      def eth_submit_hashrate(hashrate, id, opts \\ []) do
        params = [hashrate, id]

        "eth_submitHashrate" |> request(params, opts)
      end

      def db_put_string(db, key, value, opts \\ []) do
        params = [db, key, value]

        "db_putString" |> request(params, opts)
      end

      def db_get_string(db, key, opts \\ []) do
        params = [db, key]

        "db_getString" |> request(params, opts)
      end

      def db_put_hex(db, key, data, opts \\ []) do
        params = [db, key, data]

        "db_putHex" |> request(params, opts)
      end

      def db_get_hex(db, key, opts \\ []) do
        param = [db, key]

        "db_getHex" |> request(param, opts)
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
