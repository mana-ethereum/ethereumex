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
    do_increment(Application.get_env(:ethereumex, :id_reset), key)
  end

  @spec increment(atom(), integer()) :: integer()
  def increment(key, count) do
    do_increment(Application.get_env(:ethereumex, :id_reset), key, count)
  end

  @spec do_increment(binary() | nil, atom()) :: integer()
  defp do_increment(true, key) do
    :ets.insert(@tab, {key, 0})
    inc(key)
  end

  defp do_increment(_, key) do
    inc(key)
  end

  @spec do_increment(boolean() | nil, atom(), integer()) :: integer()
  defp do_increment(true, key, count) do
    :ets.insert(@tab, {key, 0})
    inc(key, count)
  end

  defp do_increment(_, key, count) do
    inc(key, count)
  end

  defp inc(key) do
    :ets.update_counter(@tab, key, {2, 1}, {key, 0})
  end

  defp inc(key, count) do
    :ets.update_counter(@tab, key, {2, count}, {key, 0})
  end
end
