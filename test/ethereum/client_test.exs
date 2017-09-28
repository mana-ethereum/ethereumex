defmodule Ethereumex.ClientTest do
  use ExUnit.Case

  import Ethereumex.Client.Methods
  alias Ethereumex.TestModule

  setup_all do
    TestModule.start_link

    :ok
  end

  test "generates json-rpc api methods" do
    methods = available_methods()

    methods
    |> Enum.reduce(0, fn({original_name, formatted_name}, id_number) ->
      {^id_number, ^original_name} = Kernel.apply(TestModule, formatted_name, [[]])

      id_number + 1
    end)
  end
end
