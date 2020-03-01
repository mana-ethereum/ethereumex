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

  @spec get(atom()) :: integer()
  def get(key) do
    case :ets.lookup(@tab, key) do
      [] -> 1
      [{^key, num}] -> num
    end
  end

  @spec increment(atom(), String.t()) :: integer()
  def increment(key, method) do
    do_increment(Application.get_env(:ethereumex, :id_reset), key, method)
  end

  @spec increment(atom(), integer(), String.t()) :: integer()
  def increment(key, count, method) do
    do_increment(Application.get_env(:ethereumex, :id_reset), key, count, method)
  end

  @spec do_increment(binary() | nil, atom(), String.t()) :: integer()
  defp do_increment(true, key, method) do
    :ets.insert(@tab, {key, 0})
    inc(key, method)
  end

  defp do_increment(_, key, method) do
    inc(key, method)
  end

  @spec do_increment(boolean() | nil, atom(), integer(), String.t()) :: integer()
  defp do_increment(true, key, count, method) do
    :ets.insert(@tab, {key, 0})
    inc(key, count, method)
  end

  defp do_increment(_, key, count, method) do
    inc(key, count, method)
  end

  defp inc(key, method) do
    _ = :telemetry.execute([:ethereumex], %{counter: 1}, %{method_name: method})
    _ = :telemetry.execute([:ethereumex, String.to_atom(method)], %{counter: 1})
    :ets.update_counter(@tab, key, {2, 1}, {key, 0})
  end

  defp inc(key, count, method) do
    _ = :telemetry.execute([:ethereumex], %{counter: 1}, %{method_name: method})
    _ = :telemetry.execute([:ethereumex, String.to_atom(method)], %{counter: 1})
    :ets.update_counter(@tab, key, {2, count}, {key, 0})
  end
end
