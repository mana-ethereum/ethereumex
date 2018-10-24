defmodule Ethereumex.CounterTest do
  use ExUnit.Case
  alias Ethereumex.Counter

  test "incrementing twice returns correct number" do
    1 = Counter.increment(:test_1)
    2 = Counter.increment(:test_1)
  end

  test "incrementing twice and updating with a count returns correct number" do
    1 = Counter.increment(:test_2)
    2 = Counter.increment(:test_2)
    4 = Counter.increment(:test_2, 2)
  end

  test "incrementing twice, updating with a count and incrementing again returns correct number" do
    1 = Counter.increment(:test_3)
    2 = Counter.increment(:test_3)
    4 = Counter.increment(:test_3, 2)
    5 = Counter.increment(:test_3)
  end
end
