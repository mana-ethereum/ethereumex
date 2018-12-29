defmodule Ethereumex.Client.BaseClient do
  alias Ethereumex.Client.Behaviour
  alias Ethereumex.Counter

  @moduledoc """
  The Base Client exposes the Ethereum Client RPC functionality. We use a macro so that exposed functions can be used in
  different behaviours (HTTP or IPC).
  """

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Behaviour
      @type error :: Behaviour.error()

      @spec web3_client_version(keyword()) :: {:ok, binary()} | error
      def web3_client_version(opts \\ []) do
        request("web3_clientVersion", [], opts)
      end

      @spec web3_sha3(binary(), keyword()) :: {:ok, binary()} | error
      def web3_sha3(data, opts \\ []) do
        params = [data]

        request("web3_sha3", params, opts)
      end

      @spec net_version(keyword()) :: {:ok, binary()} | error
      def net_version(opts \\ []) do
        request("net_version", [], opts)
      end

      @spec net_peer_count(keyword()) :: {:ok, binary()} | error
      def net_peer_count(opts \\ []) do
        request("net_peerCount", [], opts)
      end

      @spec net_listening(keyword()) :: {:ok, boolean()} | error
      def net_listening(opts \\ []) do
        request("net_listening", [], opts)
      end

      @spec eth_protocol_version(keyword()) :: {:ok, binary()} | error
      def eth_protocol_version(opts \\ []) do
        request("eth_protocolVersion", [], opts)
      end

      @spec eth_syncing(keyword()) :: {:ok, map() | boolean()} | error
      def eth_syncing(opts \\ []) do
        request("eth_syncing", [], opts)
      end

      @spec eth_coinbase(keyword()) :: {:ok, binary()} | error
      def eth_coinbase(opts \\ []) do
        request("eth_coinbase", [], opts)
      end

      @spec eth_mining(keyword()) :: {:ok, boolean()} | error
      def eth_mining(opts \\ []) do
        request("eth_mining", [], opts)
      end

      @spec eth_hashrate(keyword()) :: {:ok, binary()} | error
      def eth_hashrate(opts \\ []) do
        request("eth_hashrate", [], opts)
      end

      @spec eth_gas_price(keyword()) :: {:ok, binary()} | error
      def eth_gas_price(opts \\ []) do
        request("eth_gasPrice", [], opts)
      end

      @spec eth_accounts(keyword()) :: {:ok, [binary()]} | error
      def eth_accounts(opts \\ []) do
        request("eth_accounts", [], opts)
      end

      @spec eth_block_number(keyword()) :: {:ok, binary} | error
      def eth_block_number(opts \\ []) do
        request("eth_blockNumber", [], opts)
      end

      @spec eth_get_balance(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_balance(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        request("eth_getBalance", params, opts)
      end

      @spec eth_get_storage_at(binary(), binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_storage_at(address, position, block \\ "latest", opts \\ []) do
        params = [address, position, block]

        request("eth_getStorageAt", params, opts)
      end

      @spec eth_get_transaction_count(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_transaction_count(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        request("eth_getTransactionCount", params, opts)
      end

      @spec eth_get_block_transaction_count_by_hash(binary(), keyword()) ::
              {:ok, binary()} | error
      def eth_get_block_transaction_count_by_hash(hash, opts \\ []) do
        params = [hash]

        request("eth_getBlockTransactionCountByHash", params, opts)
      end

      @spec eth_get_block_transaction_count_by_number(binary(), keyword()) ::
              {:ok, binary()} | error
      def eth_get_block_transaction_count_by_number(block \\ "latest", opts \\ []) do
        params = [block]

        request("eth_getBlockTransactionCountByNumber", params, opts)
      end

      @spec eth_get_uncle_count_by_block_hash(binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_uncle_count_by_block_hash(hash, opts \\ []) do
        params = [hash]

        request("eth_getUncleCountByBlockHash", params, opts)
      end

      @spec eth_get_uncle_count_by_block_number(binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_uncle_count_by_block_number(block \\ "latest", opts \\ []) do
        params = [block]

        request("eth_getUncleCountByBlockNumber", params, opts)
      end

      @spec eth_get_code(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_code(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        request("eth_getCode", params, opts)
      end

      @spec eth_sign(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_sign(address, message, opts \\ []) do
        params = [address, message]

        request("eth_sign", params, opts)
      end

      @spec eth_send_transaction(map(), keyword()) :: {:ok, binary()} | error
      def eth_send_transaction(transaction, opts \\ []) do
        params = [transaction]

        request("eth_sendTransaction", params, opts)
      end

      @spec eth_send_raw_transaction(binary(), keyword()) :: {:ok, binary()} | error
      def eth_send_raw_transaction(data, opts \\ []) do
        params = [data]

        request("eth_sendRawTransaction", params, opts)
      end

      @spec eth_call(map, binary(), keyword()) :: {:ok, binary()} | error
      def eth_call(transaction, block \\ "latest", opts \\ []) do
        params = [transaction, block]

        request("eth_call", params, opts)
      end

      @spec eth_estimate_gas(map(), keyword()) :: {:ok, binary()} | error
      def eth_estimate_gas(transaction, opts \\ []) do
        params = [transaction]

        request("eth_estimateGas", params, opts)
      end

      @spec eth_get_block_by_hash(binary(), binary(), keyword()) :: {:ok, map()} | error
      def eth_get_block_by_hash(hash, full, opts \\ []) do
        params = [hash, full]

        request("eth_getBlockByHash", params, opts)
      end

      @spec eth_get_block_by_number(binary(), binary(), keyword()) :: {:ok, map()} | error
      def eth_get_block_by_number(number, full, opts \\ []) do
        params = [number, full]

        request("eth_getBlockByNumber", params, opts)
      end

      @spec eth_get_transaction_by_hash(binary(), keyword()) :: {:ok, map()} | error
      def eth_get_transaction_by_hash(hash, opts \\ []) do
        params = [hash]

        request("eth_getTransactionByHash", params, opts)
      end

      @spec eth_get_transaction_by_block_hash_and_index(binary(), binary(), keyword()) ::
              {:ok, map()} | error
      def eth_get_transaction_by_block_hash_and_index(hash, index, opts \\ []) do
        params = [hash, index]

        request("eth_getTransactionByBlockHashAndIndex", params, opts)
      end

      @spec eth_get_transaction_by_block_number_and_index(binary(), binary(), keyword()) ::
              {:ok, binary()} | error
      def eth_get_transaction_by_block_number_and_index(block, index, opts \\ []) do
        params = [block, index]

        request("eth_getTransactionByBlockNumberAndIndex", params, opts)
      end

      @spec eth_get_transaction_receipt(binary(), keyword()) :: {:ok, map()} | error
      def eth_get_transaction_receipt(hash, opts \\ []) do
        params = [hash]

        request("eth_getTransactionReceipt", params, opts)
      end

      @spec eth_get_uncle_by_block_hash_and_index(binary(), binary(), keyword()) ::
              {:ok, map()} | error
      def eth_get_uncle_by_block_hash_and_index(hash, index, opts \\ []) do
        params = [hash, index]

        request("eth_getUncleByBlockHashAndIndex", params, opts)
      end

      @spec eth_get_uncle_by_block_number_and_index(binary(), binary(), keyword()) ::
              {:ok, map()} | error
      def eth_get_uncle_by_block_number_and_index(block, index, opts \\ []) do
        params = [block, index]

        request("eth_getUncleByBlockNumberAndIndex", params, opts)
      end

      @spec eth_get_compilers(keyword()) :: {:ok, [binary()]} | error
      def eth_get_compilers(opts \\ []) do
        request("eth_getCompilers", [], opts)
      end

      @spec eth_compile_lll(binary(), keyword()) :: {:ok, binary()} | error
      def eth_compile_lll(data, opts \\ []) do
        params = [data]

        request("eth_compileLLL", params, opts)
      end

      @spec eth_compile_solidity(binary(), keyword()) :: {:ok, binary()} | error
      def eth_compile_solidity(data, opts \\ []) do
        params = [data]

        request("eth_compileSolidity", params, opts)
      end

      @spec eth_compile_serpent(binary(), keyword()) :: {:ok, binary()} | error
      def eth_compile_serpent(data, opts \\ []) do
        params = [data]

        request("eth_compileSerpent", params, opts)
      end

      @spec eth_new_filter(map(), keyword()) :: {:ok, binary()} | error
      def eth_new_filter(data, opts \\ []) do
        params = [data]

        request("eth_newFilter", params, opts)
      end

      @spec eth_new_block_filter(keyword()) :: {:ok, binary()} | error
      def eth_new_block_filter(opts \\ []) do
        request("eth_newBlockFilter", [], opts)
      end

      @spec eth_new_pending_transaction_filter(keyword()) :: {:ok, binary()} | error
      def eth_new_pending_transaction_filter(opts \\ []) do
        request("eth_newPendingTransactionFilter", [], opts)
      end

      @spec eth_uninstall_filter(binary(), keyword()) :: {:ok, boolean()} | error
      def eth_uninstall_filter(id, opts \\ []) do
        params = [id]

        request("eth_uninstallFilter", params, opts)
      end

      @spec eth_get_filter_changes(binary(), keyword()) :: {:ok, [binary()] | [map()]} | error
      def eth_get_filter_changes(id, opts \\ []) do
        params = [id]

        request("eth_getFilterChanges", params, opts)
      end

      @spec eth_get_filter_logs(binary(), keyword()) :: {:ok, [binary()] | [map()]} | error
      def eth_get_filter_logs(id, opts \\ []) do
        params = [id]

        request("eth_getFilterLogs", params, opts)
      end

      @spec eth_get_logs(map(), keyword()) :: {:ok, [binary()] | [map()]} | error
      def eth_get_logs(filter, opts \\ []) do
        params = [filter]

        request("eth_getLogs", params, opts)
      end

      @spec eth_get_work(keyword()) :: {:ok, [binary()]} | error
      def eth_get_work(opts \\ []) do
        request("eth_getWork", [], opts)
      end

      @spec eth_submit_work(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
      def eth_submit_work(nonce, header, digest, opts \\ []) do
        params = [nonce, header, digest]

        request("eth_submitWork", params, opts)
      end

      @spec eth_submit_hashrate(binary(), binary(), keyword()) :: {:ok, boolean()} | error
      def eth_submit_hashrate(hashrate, id, opts \\ []) do
        params = [hashrate, id]

        request("eth_submitHashrate", params, opts)
      end

      @spec db_put_string(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
      def db_put_string(db, key, value, opts \\ []) do
        params = [db, key, value]

        request("db_putString", params, opts)
      end

      @spec db_get_string(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def db_get_string(db, key, opts \\ []) do
        params = [db, key]

        request("db_getString", params, opts)
      end

      @spec db_put_hex(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
      def db_put_hex(db, key, data, opts \\ []) do
        params = [db, key, data]

        request("db_putHex", params, opts)
      end

      @spec db_get_hex(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def db_get_hex(db, key, opts \\ []) do
        params = [db, key]

        request("db_getHex", params, opts)
      end

      @spec shh_post(map(), keyword()) :: {:ok, boolean()} | error
      def shh_post(whisper, opts \\ []) do
        params = [whisper]

        request("shh_post", params, opts)
      end

      @spec shh_version(keyword()) :: {:ok, binary()} | error
      def shh_version(opts \\ []) do
        request("shh_version", [], opts)
      end

      @spec shh_new_identity(keyword()) :: {:ok, binary()} | error
      def shh_new_identity(opts \\ []) do
        request("shh_newIdentity", [], opts)
      end

      @spec shh_has_identity(binary(), keyword()) :: {:ok, boolean} | error
      def shh_has_identity(address, opts \\ []) do
        params = [address]

        request("shh_hasIdentity", params, opts)
      end

      @spec shh_new_group(keyword()) :: {:ok, binary()} | error
      def shh_new_group(opts \\ []) do
        request("shh_newGroup", [], opts)
      end

      @spec shh_add_to_group(binary(), keyword()) :: {:ok, boolean()} | error
      def shh_add_to_group(address, opts \\ []) do
        params = [address]

        request("shh_addToGroup", params, opts)
      end

      @spec shh_new_filter(map(), keyword()) :: {:ok, binary()} | error
      def shh_new_filter(filter_options, opts \\ []) do
        params = [filter_options]

        request("shh_newFilter", params, opts)
      end

      @spec shh_uninstall_filter(binary(), keyword()) :: {:ok, binary()} | error
      def shh_uninstall_filter(filter_id, opts \\ []) do
        params = [filter_id]

        request("shh_uninstallFilter", params, opts)
      end

      @spec shh_get_filter_changes(binary(), keyword()) :: {:ok, [map()]} | error
      def shh_get_filter_changes(filter_id, opts \\ []) do
        params = [filter_id]

        request("shh_getFilterChanges", params, opts)
      end

      @spec shh_get_messages(binary(), keyword()) :: {:ok, [map()]} | error
      def shh_get_messages(filter_id, opts \\ []) do
        params = [filter_id]

        "shh_getMessages" |> request(params, opts)
      end

      @spec add_request_info(binary, [binary] | [map]) :: map
      defp add_request_info(method_name, params \\ []) do
        %{}
        |> Map.put("method", method_name)
        |> Map.put("jsonrpc", "2.0")
        |> Map.put("params", params)
      end

      @spec request(binary(), list(binary() | boolean | map), keyword()) ::
              {:ok, any() | [any()]} | error
      def request(_name, _params, batch: true, url: _url),
        do: raise("Cannot use batch and url options at the same time")

      def request(name, params, batch: true) do
        name |> add_request_info(params)
      end

      def request(name, params, opts) do
        name
        |> add_request_info(params)
        |> server_request(opts)
      end

      @spec batch_request([{atom(), list(binary())}]) :: {:ok, [any()]} | error
      def batch_request(methods) do
        methods
        |> Enum.map(fn {method, params} ->
          opts = [batch: true]
          params = params ++ [opts]

          apply(__MODULE__, method, params)
        end)
        |> server_request
      end

      @spec single_request(map(), []) :: {:ok, any() | [any()]} | error
      def single_request(payload, opts \\ []) do
        payload
        |> encode_payload
        |> post_request(opts)
      end

      @spec encode_payload(map()) :: binary()
      defp encode_payload(payload) do
        payload |> Jason.encode!()
      end

      @spec format_batch([map()]) :: [map() | nil | binary()]
      def format_batch(list) do
        list
        |> Enum.sort(fn %{"id" => id1}, %{"id" => id2} ->
          id1 <= id2
        end)
        |> Enum.map(fn %{"result" => result} ->
          result
        end)
      end

      defp post_request(payload, opts) do
        {:error, :not_implemented}
      end

      # The function that a behavior like HTTP or IPC needs to implement.
      defoverridable post_request: 2

      @spec server_request(list(map()) | map(), list()) :: {:ok, [any()]} | {:ok, any()} | error
      defp server_request(params, opts \\ []) do
        params
        |> prepare_request
        |> request(opts)
      end

      defp prepare_request(params) when is_list(params) do
        id = Counter.increment(:rpc_counter)

        params =
          params
          |> Enum.with_index()
          |> Enum.map(fn {req_data, index} ->
            Map.put(req_data, "id", index + id)
          end)

        _ = Counter.increment(:rpc_counter, id + Enum.count(params))
        params
      end

      defp prepare_request(params), do: Map.put(params, "id", Counter.increment(:rpc_counter))

      defp request(params, opts) do
        __MODULE__.single_request(params, opts)
      end
    end
  end
end
