defmodule Ethereumes.Client.Methods do
  use ExUnit.Case
  alias Ethereumex.Client.Methods

  test "returns methods without params" do
    methods = Methods.methods_without_params

    ^methods =
      [
        {"web3_clientVersion", :web3_client_version},
        {"net_version", :net_version},
        {"net_peerCount", :net_peer_count},
        {"net_listening", :net_listening},
        {"eth_protocolVersion", :eth_protocol_version},
        {"eth_syncing", :eth_syncing},
        {"eth_coinbase", :eth_coinbase},
        {"eth_mining", :eth_mining},
        {"eth_hashrate", :eth_hashrate},
        {"eth_gasPrice", :eth_gas_price},
        {"eth_accounts", :eth_accounts},
        {"eth_blockNumber", :eth_block_number},
        {"eth_getCompilers", :eth_get_compilers},
        {"eth_newBlockFilter", :eth_new_block_filter},
        {"eth_newPendingTransactionFilter", :eth_new_pending_transaction_filter},
        {"eth_getFilterChanges", :eth_get_filter_changes},
        {"eth_getWork", :eth_get_work},
        {"shh_version", :shh_version},
        {"shh_newIdentity", :shh_new_identity},
        {"shh_newGroup", :shh_new_group}
      ]
  end

  test "returns methods with params" do
    methods = Methods.methods_with_params

    ^methods =
      [
        {"web3_sha3", :web3_sha3},
        {"eth_getBalance", :eth_get_balance},
        {"eth_getStorageAt", :eth_get_storage_at},
        {"eth_getTransactionCount", :eth_get_transaction_count},
        {"eth_getBlockTransactionCountByHash", :eth_get_block_transaction_count_by_hash},
        {"eth_getBlockTransactionCountByNumber", :eth_get_block_transaction_count_by_number},
        {"eth_getUncleCountByBlockHash", :eth_get_uncle_count_by_block_hash},
        {"eth_getUncleCountByBlockNumber", :eth_get_uncle_count_by_block_number},
        {"eth_getCode", :eth_get_code},
        {"eth_sign", :eth_sign},
        {"eth_sendTransaction", :eth_send_transaction},
        {"eth_sendRawTransaction", :eth_send_raw_transaction},
        {"eth_call", :eth_call},
        {"eth_estimateGas", :eth_estimate_gas},
        {"eth_getBlockByHash", :eth_get_block_by_hash},
        {"eth_getBlockByNumber", :eth_get_block_by_number},
        {"eth_getTransactionByHash", :eth_get_transaction_by_hash},
        {"eth_getTransactionByBlockHashAndIndex", :eth_get_transaction_by_block_hash_and_index},
        {"eth_getTransactionByBlockNumberAndIndex", :eth_get_transaction_by_block_number_and_index},
        {"eth_getTransactionReceipt", :eth_get_transaction_receipt},
        {"eth_getUncleByBlockHashAndIndex", :eth_get_uncle_by_block_hash_and_index},
        {"eth_getUncleByBlockNumberAndIndex", :eth_get_uncle_by_block_number_and_index},
        {"eth_compileLLL", :eth_compile_lll},
        {"eth_compileSolidity", :eth_compile_solidity},
        {"eth_compileSerpent", :eth_compile_serpent},
        {"eth_newFilter", :eth_new_filter},
        {"eth_uninstallFilter", :eth_uninstall_filter},
        {"eth_getFilterLogs", :eth_get_filter_logs},
        {"eth_getLogs", :eth_get_logs},
        {"eth_submitWork", :eth_submit_work},
        {"eth_submitHashrate", :eth_submit_hashrate},
        {"db_putString", :db_put_string},
        {"db_getString", :db_get_string},
        {"db_putHex", :db_put_hex},
        {"db_getHex", :db_get_hex},
        {"shh_post", :shh_post},
        {"shh_hasIdentity", :shh_has_identity},
        {"shh_addToGroup", :shh_add_to_group},
        {"shh_newFilter", :shh_new_filter},
        {"shh_uninstallFilter", :shh_uninstall_filter},
        {"shh_getFilterChanges", :shh_get_filter_changes},
        {"shh_getMessages", :shh_get_messages}
      ]
  end
end
