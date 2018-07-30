defmodule Ethereumex.Client.MacroTest do
  use ExUnit.Case
  alias Ethereumex.HttpClient

  setup_all do
    HttpClient.start_link()

    :ok
  end

  @tag :macro
  describe "Macro.request/3" do
    test "throws and error when using the batch and node options" do
      assert_raise(RuntimeError, fn -> HttpClient.request("web3_clientVersion", [], batch: true, url: "http://localhost:8545") end)
    end

    test "using the application url" do
      {:ok, _} = HttpClient.request("web3_clientVersion", [], [])
    end

    test "supply a request url" do
      {:error, :econnrefused} = HttpClient.request("web3_clientVersion", [], url: "http://localhost:1234")
    end
  end
end
