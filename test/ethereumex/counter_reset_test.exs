defmodule Ethereumex.ResetLockTest do
  use ExUnit.Case
  alias Ethereumex.Counter

  setup_all do
    Application.put_env(:ethereumex, :id_reset, true)

    on_exit(fn ->
      Application.put_env(:ethereumex, :id_reset, false)
    end)
  end

  test "incrementing twice returns correct locked binary" do
    1 = Counter.increment(:test_11, "method_11")
    1 = Counter.increment(:test_11, "method_11")
  end

  test "incrementing twice and updating with a count returns correct locked binary" do
    1 = Counter.increment(:test_22, "method_22")
    2 = Counter.increment(:test_22, 2, "method_22")
  end

  test "incrementing twice, updating with a count and incrementing again returns correct locked binary" do
    1 = Counter.increment(:test_33, "method_33")
    2 = Counter.increment(:test_33, 2, "method_33")
    1 = Counter.increment(:test_33, "method_33")
  end
end
