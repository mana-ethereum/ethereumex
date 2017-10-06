defmodule Ethereumex.Client.Behaviour do
  @type return_type :: {:ok, map()} | {:error, map()} | {:error, atom()}

  # API methods

  @callback web3_client_version() :: return_type
  @callback web3_sha3(binary()) :: return_type
  @callback net_version() :: return_type
  @callback net_peer_count() :: return_type
  @callback net_listening() :: return_type
  @callback eth_protocol_version() :: return_type
  @callback eth_syncing() :: return_type
  @callback eth_coinbase() :: return_type
  @callback eth_mining() :: return_type
  @callback eth_hashrate() :: return_type
  @callback eth_gas_price() :: return_type
  @callback eth_accounts() :: return_type
  @callback eth_block_number() :: return_type
  @callback eth_get_balance(binary(), binary()) :: return_type
  @callback eth_get_storage_at(binary(), binary(), binary()) :: return_type
  @callback eth_get_transaction_count(binary(), binary()) :: return_type
  @callback eth_get_block_transaction_count_by_hash(binary()) :: return_type
  @callback eth_get_block_transaction_count_by_number(binary()) :: return_type
  @callback eth_get_uncle_count_by_block_hash() :: return_type
  @callback eth_get_uncle_count_by_block_number() :: return_type
  @callback eth_get_code() :: return_type
  @callback eth_sign() :: return_type
  @callback eth_send_transaction() :: return_type
  @callback eth_send_raw_transaction() :: return_type
  @callback eth_call() :: return_type
  @callback eth_estimate_gas() :: return_type
  @callback eth_get_block_by_hash() :: return_type
  @callback eth_get_block_by_number() :: return_type
  @callback eth_get_transaction_by_hash() :: return_type
  @callback eth_get_transaction_by_block_hash_and_index() :: return_type
  @callback eth_get_transaction_by_block_number_and_index() :: return_type
  @callback eth_get_transaction_receipt() :: return_type
  @callback eth_get_uncle_by_block_hash_and_index() :: return_type
  @callback eth_get_uncle_by_block_number_and_index() :: return_type
  @callback eth_get_compilers() :: return_type
  @callback eth_compile_lll() :: return_type
  @callback eth_compile_solidity() :: return_type
  @callback eth_compile_serpent() :: return_type
  @callback eth_new_filter() :: return_type
  @callback eth_new_block_filter() :: return_type
  @callback eth_new_pending_transaction_filter() :: return_type
  @callback eth_uninstall_filter() :: return_type
  @callback eth_get_filter_changes() :: return_type
  @callback eth_get_filter_logs() :: return_type
  @callback eth_get_logs() :: return_type
  @callback eth_get_work() :: return_type
  @callback eth_submit_work() :: return_type
  @callback eth_submit_hashrate() :: return_type
  @callback db_put_string() :: return_type
  @callback db_get_string() :: return_type
  @callback db_put_hex() :: return_type
  @callback db_get_hex() :: return_type
  @callback shh_post() :: return_type
  @callback shh_version() :: return_type
  @callback shh_new_identity() :: return_type
  @callback shh_has_identity() :: return_type
  @callback shh_new_group() :: return_type
  @callback shh_add_to_group() :: return_type
  @callback shh_new_filter() :: return_type
  @callback shh_uninstall_filter() :: return_type
  @callback shh_get_filter_changes() :: return_type
  @callback shh_get_messages() :: return_type

  # actual request

  @callback request(map()) :: return_type
end
