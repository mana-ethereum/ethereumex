defmodule Ethereumex.CounterTest do
  use ExUnit.Case
  alias Ethereumex.Counter

  setup_all do
    on_exit(fn ->
      Application.put_env(:ethereumex, :adapter, nil)
      Application.put_env(:ethereumex, :adapter_options, nil)
    end)

    :ok
  end

  test "incrementing twice returns correct number" do
    1 = Counter.increment(:test_1, "method_1")
    2 = Counter.increment(:test_1, "method_1")
  end

  test "incrementing twice and updating with a count returns correct number" do
    1 = Counter.increment(:test_2, "method_2")
    2 = Counter.increment(:test_2, "method_2")
    4 = Counter.increment(:test_2, 2, ["method_2"])
  end

  test "incrementing twice, updating with a count and incrementing again returns correct number" do
    1 = Counter.increment(:test_3, "method_3")
    2 = Counter.increment(:test_3, "method_3")
    4 = Counter.increment(:test_3, 2, ["method_3"])
    5 = Counter.increment(:test_3, "method_3")
  end

  test "an adapter gets called with increment/2" do
    :ok = Application.put_env(:ethereumex, :adapter, __MODULE__.Adapter)
    1 = Counter.increment(:test_4, "method_4")
    assert_receive({"method_4", 1, []})
    3 = Counter.increment(:test_4, 2, "eth_batch")
    assert_receive({"eth_batch", 1, []})

    :ok = Application.put_env(:ethereumex, :adapter_options, sample_rate: 0.5)
    5 = Counter.increment(:test_4, 2, "eth_batch")
    assert_receive({"eth_batch", 1, [sample_rate: 0.5]})
  end

  defmodule Adapter do
    def increment(method, count, options), do: Kernel.send(self(), {method, count, options})
  end
end
