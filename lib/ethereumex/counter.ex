defmodule Ethereumex.Counter do
  @moduledoc """
  An application wide RPC2Ethereum client request counter.
  """
  @tab :rpc_requests_counter

  @spec setup() :: :ok
  def setup() do
    @tab =
      :ets.new(@tab, [
        :set,
        :named_table,
        :public,
        write_concurrency: true
      ])

    :ok
  end

  @spec increment(atom()) :: integer()
  def increment(key) do
    :ets.update_counter(@tab, key, {2, 1}, {key, 0})
  end

  @spec increment(atom(), integer()) :: integer()
  def increment(key, count) do
    :ets.update_counter(@tab, key, {2, count}, {key, 0})
  end
end
