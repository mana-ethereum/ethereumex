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
    do_increment(Application.get_env(:ethereumex, :id_lock), key)
  end

  @spec increment(atom(), integer()) :: integer()
  def increment(key, count) do
    do_increment(Application.get_env(:ethereumex, :id_lock), key, count)
  end

  @spec do_increment(binary() | nil, atom()) :: integer()
  defp do_increment(nil, key) do
    :ets.update_counter(@tab, key, {2, 1}, {key, 0})
  end

  defp do_increment(id_lock, _key) do
    id_lock
  end

  @spec do_increment(binary() | nil, atom(), integer()) :: integer()
  defp do_increment(nil, key, count) do
    :ets.update_counter(@tab, key, {2, count}, {key, 0})
  end

  @spec do_increment(binary() | nil, atom(), integer()) :: integer()
  defp do_increment(id_lock, _key, _count) do
    id_lock
  end
end
