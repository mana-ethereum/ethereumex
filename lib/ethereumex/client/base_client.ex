defmodule Ethereumex.Client.BaseClient do
  alias Ethereumex.Client.{Server, Behaviour}
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      @behaviour Behaviour
      @type error :: Behaviour.error()

      @spec web3_client_version(keyword()) :: {:ok, binary()} | error
      def web3_client_version(opts \\ []) do
        "web3_clientVersion" |> request([], opts)
      end

      @spec web3_sha3(binary(), keyword()) :: {:ok, binary()} | error
      def web3_sha3(data, opts \\ []) do
        params = [data]

        "web3_sha3" |> request(params, opts)
      end

      @spec net_version(keyword()) :: {:ok, binary()} | error
      def net_version(opts \\ []) do
        "net_version" |> request([], opts)
      end

      @spec net_peer_count(keyword()) :: {:ok, binary()} | error
      def net_peer_count(opts \\ []) do
        "net_peerCount" |> request([], opts)
      end

      @spec net_listening(keyword()) :: {:ok, boolean()} | error
      def net_listening(opts \\ []) do
        "net_listening" |> request([], opts)
      end

      @spec eth_protocol_version(keyword()) :: {:ok, binary()} | error
      def eth_protocol_version(opts \\ []) do
        "eth_protocolVersion" |> request([], opts)
      end

      @spec eth_syncing(keyword()) :: {:ok, map() | boolean()} | error
      def eth_syncing(opts \\ []) do
        "eth_syncing" |> request([], opts)
      end

      @spec eth_coinbase(keyword()) :: {:ok, binary()} | error
      def eth_coinbase(opts \\ []) do
        "eth_coinbase" |> request([], opts)
      end

      @spec eth_mining(keyword()) :: {:ok, boolean()} | error
      def eth_mining(opts \\ []) do
        "eth_mining" |> request([], opts)
      end

      @spec eth_hashrate(keyword()) :: {:ok, binary()} | error
      def eth_hashrate(opts \\ []) do
        "eth_hashrate" |> request([], opts)
      end

      @spec eth_gas_price(keyword()) :: {:ok, binary()} | error
      def eth_gas_price(opts \\ []) do
        "eth_gasPrice" |> request([], opts)
      end

      @spec eth_accounts(keyword()) :: {:ok, [binary()]} | error
      def eth_accounts(opts \\ []) do
        "eth_accounts" |> request([], opts)
      end

      @spec eth_block_number(keyword()) :: {:ok, binary} | error
      def eth_block_number(opts \\ []) do
        "eth_blockNumber" |> request([], opts)
      end

      @spec eth_get_balance(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_balance(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        "eth_getBalance" |> request(params, opts)
      end

      @spec eth_get_storage_at(binary(), binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_storage_at(address, position, block \\ "latest", opts \\ []) do
        params = [address, position, block]

        "eth_getStorageAt" |> request(params, opts)
      end

      @spec eth_get_transaction_count(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_transaction_count(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        "eth_getTransactionCount" |> request(params, opts)
      end

      @spec eth_get_block_transaction_count_by_hash(binary(), keyword()) ::
              {:ok, binary()} | error
      def eth_get_block_transaction_count_by_hash(hash, opts \\ []) do
        params = [hash]

        "eth_getBlockTransactionCountByHash" |> request(params, opts)
      end

      @spec eth_get_block_transaction_count_by_number(binary(), keyword()) ::
              {:ok, binary()} | error
      def eth_get_block_transaction_count_by_number(block \\ "latest", opts \\ []) do
        params = [block]

        "eth_getBlockTransactionCountByNumber" |> request(params, opts)
      end

      @spec eth_get_uncle_count_by_block_hash(binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_uncle_count_by_block_hash(hash, opts \\ []) do
        params = [hash]

        "eth_getUncleCountByBlockHash" |> request(params, opts)
      end

      @spec eth_get_uncle_count_by_block_number(binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_uncle_count_by_block_number(block \\ "latest", opts \\ []) do
        params = [block]

        "eth_getUncleCountByBlockNumber" |> request(params, opts)
      end

      @spec eth_get_code(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_get_code(address, block \\ "latest", opts \\ []) do
        params = [address, block]

        "eth_getCode" |> request(params, opts)
      end

      @spec eth_sign(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_sign(address, message, opts \\ []) do
        params = [address, message]

        "eth_sign" |> request(params, opts)
      end

      @spec eth_send_transaction(map(), keyword()) :: {:ok, binary()} | error
      def eth_send_transaction(transaction, opts \\ []) do
        params = [transaction]

        "eth_sendTransaction" |> request(params, opts)
      end

      @spec eth_send_raw_transaction(binary(), keyword()) :: {:ok, binary()} | error
      def eth_send_raw_transaction(data, opts \\ []) do
        params = [data]

        "eth_sendRawTransaction" |> request(params, opts)
      end

      @spec eth_call(map, binary(), keyword()) :: {:ok, binary()} | error
      def eth_call(transaction, block \\ "latest", opts \\ []) do
        params = [transaction, block]

        "eth_call" |> request(params, opts)
      end

      @spec eth_estimate_gas(map(), binary(), keyword()) :: {:ok, binary()} | error
      def eth_estimate_gas(transaction, block \\ "latest", opts \\ []) do
        params = [transaction, block]

        "eth_estimateGas" |> request(params, opts)
      end

      @spec eth_get_block_by_hash(binary(), binary(), keyword()) :: {:ok, map()} | error
      def eth_get_block_by_hash(hash, full, opts \\ []) do
        params = [hash, full]

        "eth_getBlockByHash" |> request(params, opts)
      end

      @spec eth_get_block_by_number(binary(), binary(), keyword()) :: {:ok, map()} | error
      def eth_get_block_by_number(number, full, opts \\ []) do
        params = [number, full]

        "eth_getBlockByNumber" |> request(params, opts)
      end

      @spec eth_get_transaction_by_hash(binary(), keyword()) :: {:ok, map()} | error
      def eth_get_transaction_by_hash(hash, opts \\ []) do
        params = [hash]

        "eth_getTransactionByHash" |> request(params, opts)
      end

      @spec eth_get_transaction_by_block_hash_and_index(binary(), binary(), keyword()) ::
              {:ok, map()} | error
      def eth_get_transaction_by_block_hash_and_index(hash, index, opts \\ []) do
        params = [hash, index]

        "eth_getTransactionByBlockHashAndIndex" |> request(params, opts)
      end

      @spec eth_get_transaction_by_block_number_and_index(binary(), binary(), keyword()) ::
              {:ok, binary()} | error
      def eth_get_transaction_by_block_number_and_index(block, index, opts \\ []) do
        params = [block, index]

        "eth_getTransactionByBlockNumberAndIndex" |> request(params, opts)
      end

      @spec eth_get_transaction_receipt(binary(), keyword()) :: {:ok, map()} | error
      def eth_get_transaction_receipt(hash, opts \\ []) do
        params = [hash]

        "eth_getTransactionReceipt" |> request(params, opts)
      end

      @spec eth_get_uncle_by_block_hash_and_index(binary(), binary(), keyword()) ::
              {:ok, map()} | error
      def eth_get_uncle_by_block_hash_and_index(hash, index, opts \\ []) do
        params = [hash, index]

        "eth_getUncleByBlockHashAndIndex" |> request(params, opts)
      end

      @spec eth_get_uncle_by_block_number_and_index(binary(), binary(), keyword()) ::
              {:ok, map()} | error
      def eth_get_uncle_by_block_number_and_index(block, index, opts \\ []) do
        params = [block, index]

        "eth_getUncleByBlockNumberAndIndex" |> request(params, opts)
      end

      @spec eth_get_compilers(keyword()) :: {:ok, [binary()]} | error
      def eth_get_compilers(opts \\ []) do
        "eth_getCompilers" |> request([], opts)
      end

      @spec eth_compile_lll(binary(), keyword()) :: {:ok, binary()} | error
      def eth_compile_lll(data, opts \\ []) do
        params = [data]

        "eth_compileLLL" |> request(params, opts)
      end

      @spec eth_compile_solidity(binary(), keyword()) :: {:ok, binary()} | error
      def eth_compile_solidity(data, opts \\ []) do
        params = [data]

        "eth_compileSolidity" |> request(params, opts)
      end

      @spec eth_compile_serpent(binary(), keyword()) :: {:ok, binary()} | error
      def eth_compile_serpent(data, opts \\ []) do
        params = [data]

        "eth_compileSerpent" |> request(params, opts)
      end

      @spec eth_new_filter(map(), keyword()) :: {:ok, binary()} | error
      def eth_new_filter(data, opts \\ []) do
        params = [data]

        "eth_newFilter" |> request(params, opts)
      end

      @spec eth_new_block_filter(keyword()) :: {:ok, binary()} | error
      def eth_new_block_filter(opts \\ []) do
        "eth_newBlockFilter" |> request([], opts)
      end

      @spec eth_new_pending_transaction_filter(keyword()) :: {:ok, binary()} | error
      def eth_new_pending_transaction_filter(opts \\ []) do
        "eth_newPendingTransactionFilter" |> request([], opts)
      end

      @spec eth_uninstall_filter(binary(), keyword()) :: {:ok, boolean()} | error
      def eth_uninstall_filter(id, opts \\ []) do
        params = [id]

        "eth_uninstallFilter" |> request(params, opts)
      end

      @spec eth_get_filter_changes(binary(), keyword()) :: {:ok, [binary()] | [map()]} | error
      def eth_get_filter_changes(id, opts \\ []) do
        params = [id]

        "eth_getFilterChanges" |> request(params, opts)
      end

      @spec eth_get_filter_logs(binary(), keyword()) :: {:ok, [binary()] | [map()]} | error
      def eth_get_filter_logs(id, opts \\ []) do
        params = [id]

        "eth_getFilterLogs" |> request(params, opts)
      end

      @spec eth_get_logs(map(), keyword()) :: {:ok, [binary()] | [map()]} | error
      def eth_get_logs(filter, opts \\ []) do
        params = [filter]

        "eth_getLogs" |> request(params, opts)
      end

      @spec eth_get_work(keyword()) :: {:ok, [binary()]} | error
      def eth_get_work(opts \\ []) do
        "eth_getWork" |> request([], opts)
      end

      @spec eth_submit_work(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
      def eth_submit_work(nonce, header, digest, opts \\ []) do
        params = [nonce, header, digest]

        "eth_submitWork" |> request(params, opts)
      end

      @spec eth_submit_hashrate(binary(), binary(), keyword()) :: {:ok, boolean()} | error
      def eth_submit_hashrate(hashrate, id, opts \\ []) do
        params = [hashrate, id]

        "eth_submitHashrate" |> request(params, opts)
      end

      @spec db_put_string(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
      def db_put_string(db, key, value, opts \\ []) do
        params = [db, key, value]

        "db_putString" |> request(params, opts)
      end

      @spec db_get_string(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def db_get_string(db, key, opts \\ []) do
        params = [db, key]

        "db_getString" |> request(params, opts)
      end

      @spec db_put_hex(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
      def db_put_hex(db, key, data, opts \\ []) do
        params = [db, key, data]

        "db_putHex" |> request(params, opts)
      end

      @spec db_get_hex(binary(), binary(), keyword()) :: {:ok, binary()} | error
      def db_get_hex(db, key, opts \\ []) do
        params = [db, key]

        "db_getHex" |> request(params, opts)
      end

      @spec shh_post(map(), keyword()) :: {:ok, boolean()} | error
      def shh_post(whisper, opts \\ []) do
        params = [whisper]

        "shh_post" |> request(params, opts)
      end

      @spec shh_version(keyword()) :: {:ok, binary()} | error
      def shh_version(opts \\ []) do
        "shh_version" |> request([], opts)
      end

      @spec shh_new_identity(keyword()) :: {:ok, binary()} | error
      def shh_new_identity(opts \\ []) do
        "shh_newIdentity" |> request([], opts)
      end

      @spec shh_has_identity(binary(), keyword()) :: {:ok, boolean} | error
      def shh_has_identity(address, opts \\ []) do
        params = [address]

        "shh_hasIdentity" |> request(params, opts)
      end

      @spec shh_new_group(keyword()) :: {:ok, binary()} | error
      def shh_new_group(opts \\ []) do
        "shh_newGroup" |> request([], opts)
      end

      @spec shh_add_to_group(binary(), keyword()) :: {:ok, boolean()} | error
      def shh_add_to_group(address, opts \\ []) do
        params = [address]

        "shh_addToGroup" |> request(params, opts)
      end

      @spec shh_new_filter(map(), keyword()) :: {:ok, binary()} | error
      def shh_new_filter(filter_options, opts \\ []) do
        params = [filter_options]

        "shh_newFilter" |> request(params, opts)
      end

      @spec shh_uninstall_filter(binary(), keyword()) :: {:ok, binary()} | error
      def shh_uninstall_filter(filter_id, opts \\ []) do
        params = [filter_id]

        "shh_uninstallFilter" |> request(params, opts)
      end

      @spec shh_get_filter_changes(binary(), keyword()) :: {:ok, [map()]} | error
      def shh_get_filter_changes(filter_id, opts \\ []) do
        params = [filter_id]

        "shh_getFilterChanges" |> request(params, opts)
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
        |> post_request(opts, payload["id"])
      end

      @spec encode_payload(map()) :: binary()
      defp encode_payload(payload) do
        payload |> Poison.encode!()
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

      defp post_request(payload, opts, request_id) do
        {:error, :not_implemented}
      end

      defoverridable post_request: 3

      defp server_request(params, opts \\ []) do
        timeout = Keyword.get(opts, :request_timeout, Ethereumex.Config.request_timeout())
        GenServer.call(__MODULE__, {:request, params, opts}, timeout)
      end

      def start_link do
        Server.start_link(__MODULE__)
      end

      def reset_id do
        GenServer.cast(__MODULE__, :reset_id)
      end
    end
  end
end
