defmodule Ethereumex.CounterTest do
  use ExUnit.Case
  alias Ethereumex.Counter

  setup do
    handler_id = {:ethereumex_handler, :rand.uniform(100)}

    on_exit(fn ->
      :telemetry.detach(handler_id)
    end)

    {:ok, handler_id: handler_id}
  end

  test "incrementing twice returns correct number" do
    1 = Counter.increment(:test_1, "method_1")
    2 = Counter.increment(:test_1, "method_1")
  end

  test "incrementing twice and updating with a count returns correct number" do
    1 = Counter.increment(:test_2, "method_2")
    2 = Counter.increment(:test_2, "method_2")
    4 = Counter.increment(:test_2, 2, "method_2")
  end

  test "incrementing twice, updating with a count and incrementing again returns correct number" do
    1 = Counter.increment(:test_3, "method_3")
    2 = Counter.increment(:test_3, "method_3")
    4 = Counter.increment(:test_3, 2, "method_3")
    5 = Counter.increment(:test_3, "method_3")
  end

  test "telemetry handler attached with method name gets called with increment/2", %{
    handler_id: handler_id
  } do
    method_4 = "method_4"
    attach(handler_id, [:ethereumex, String.to_atom(method_4)])
    :ok = Application.put_env(:ethereumex, :adapter, __MODULE__.Adapter)
    1 = Counter.increment(:test_4, method_4)
    assert_received({:event, [:ethereumex, :method_4], %{counter: 1}, %{}})
  end

  test "telemetry handler attached without method name gets called with increment/2", %{
    handler_id: handler_id
  } do
    eth_batch = "eth_batch"
    attach(handler_id, [:ethereumex])
    2 = Counter.increment(:test_5, 2, eth_batch)
    assert_received({:event, [:ethereumex], %{counter: 1}, %{method_name: "eth_batch"}})
  end

  defp attach(handler_id, event) do
    :telemetry.attach(
      handler_id,
      event,
      fn event, measurements, metadata, _ ->
        send(self(), {:event, event, measurements, metadata})
      end,
      nil
    )
  end
end
