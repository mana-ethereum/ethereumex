defmodule Ethereumex.Client.Behaviour do
  @type error :: {:error, map() | binary() | atom()}

  # API methods

  @callback web3_client_version(keyword()) :: {:ok, binary()} | error
  @callback web3_sha3(binary(), keyword()) :: {:ok, binary()} | error
  @callback net_version(keyword()) :: {:ok, binary()} | error
  @callback net_peer_count(keyword()) :: {:ok, binary()} | error
  @callback net_listening(keyword()) :: {:ok, boolean()} | error
  @callback eth_protocol_version(keyword()) :: {:ok, binary()} | error
  @callback eth_syncing(keyword()) :: {:ok, map() | true} | error
  @callback eth_coinbase(keyword()) :: {:ok, binary()} | error
  @callback eth_mining(keyword()) :: {:ok, boolean()} | error
  @callback eth_hashrate(keyword()) :: {:ok, binary()} | error
  @callback eth_gas_price(keyword()) :: {:ok, binary()} | error
  @callback eth_accounts(keyword()) :: {:ok, [binary()]} | error
  @callback eth_block_number(keyword()) :: {:ok, binary} | error
  @callback eth_get_balance(binary(), binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_storage_at(binary(), binary(), binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_transaction_count(binary(), binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_block_transaction_count_by_hash(binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_block_transaction_count_by_number(binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_uncle_count_by_block_hash(binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_uncle_count_by_block_number(binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_code(binary(), binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_sign(binary(), binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_send_transaction(map(), keyword()) :: {:ok, binary()} | error
  @callback eth_send_raw_transaction(binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_call(map, binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_estimate_gas(map(), binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_block_by_hash(binary(), binary(), keyword()) :: {:ok, map()} | error
  @callback eth_get_block_by_number(binary(), binary(), keyword()) :: {:ok, map()} | error
  @callback eth_get_transaction_by_hash(binary(), keyword()) :: {:ok, map()} | error
  @callback eth_get_transaction_by_block_hash_and_index(binary(), binary(), keyword()) :: {:ok, map()} | error
  @callback eth_get_transaction_by_block_number_and_index(binary(), binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_get_transaction_receipt(binary(), keyword()) :: {:ok, map()} | error
  @callback eth_get_uncle_by_block_hash_and_index(binary(), binary(), keyword()) :: {:ok, map()} | error
  @callback eth_get_uncle_by_block_number_and_index(binary(), binary(), keyword()) :: {:ok, map()} | error
  @callback eth_get_compilers(keyword()) :: {:ok, [binary()]} | error
  @callback eth_compile_lll(binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_compile_solidity(binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_compile_serpent(binary(), keyword()) :: {:ok, binary()} | error
  @callback eth_new_filter(map(), keyword()) :: {:ok, binary()} | error
  @callback eth_new_block_filter(keyword()) :: {:ok, binary()} | error
  @callback eth_new_pending_transaction_filter(keyword()) :: {:ok, binary()} | error
  @callback eth_uninstall_filter(binary(), keyword()) :: {:ok, boolean()} | error
  @callback eth_get_filter_changes(binary(), keyword()) :: {:ok, [binary()] | [map()]} | error
  @callback eth_get_filter_logs(binary(), keyword()) :: {:ok, [binary()] | [map()]} | error
  @callback eth_get_logs(map(), keyword()) :: {:ok, [binary()] | [map()]} | error
  @callback eth_get_work(keyword()) :: {:ok, [binary()]} | error
  @callback eth_submit_work(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
  @callback eth_submit_hashrate(binary(), binary(), keyword()) :: {:ok, boolean()} | error
  @callback db_put_string(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
  @callback db_get_string(binary(), binary(), keyword()) :: {:ok, binary()} | error
  @callback db_put_hex(binary(), binary(), binary(), keyword()) :: {:ok, boolean()} | error
  @callback db_get_hex(binary(), binary(), keyword()) :: {:ok, binary()} | error
  @callback shh_post(map(), keyword()) :: {:ok, boolean()} | error
  @callback shh_version(keyword()) :: {:ok, binary()} | error
  @callback shh_new_identity(keyword()) :: {:ok, binary()} | error
  @callback shh_has_identity(binary(), keyword()) :: {:ok, boolean} | error
  @callback shh_new_group(keyword()) :: {:ok, binary()} | error
  @callback shh_add_to_group(binary(), keyword()) :: {:ok, boolean()} | error
  @callback shh_new_filter(map(), keyword()) :: {:ok, binary()} | error
  @callback shh_uninstall_filter(binary(), keyword()) :: {:ok, binary()} | error
  @callback shh_get_filter_changes(binary(), keyword()) :: {:ok, [map()]} | error
  @callback shh_get_messages(binary(), keyword()) :: {:ok, [map()]} | error

  # actual request methods

  @callback request(binary(), list(binary()), keyword()) :: {:ok, any() | [any()]} | error
  @callback single_request(map()) :: {:ok, any() | [any()]} | error
  @callback batch_request([{atom(), list(binary())}]) :: {:ok, [any()]} | error
end
