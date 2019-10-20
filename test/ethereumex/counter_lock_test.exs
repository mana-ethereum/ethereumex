defmodule Ethereumex.CounterLockTest do
  use ExUnit.Case
  alias Ethereumex.Counter

  setup do
    Application.put_env(:ethereumex, :id_lock, "0")

    on_exit(fn ->
      Application.put_env(:ethereumex, :id_lock, nil)
    end)
  end

  test "incrementing twice returns correct locked binary" do
    "0" = Counter.increment(:test_1)
    "0" = Counter.increment(:test_1)
  end

  test "incrementing twice and updating with a count returns correct locked binary" do
    "0" = Counter.increment(:test_2)
    "0" = Counter.increment(:test_2, 2)
  end

  test "incrementing twice, updating with a count and incrementing again returns correct locked binary" do
    "0" = Counter.increment(:test_3)
    "0" = Counter.increment(:test_3, 2)
    "0" = Counter.increment(:test_3)
  end
end
