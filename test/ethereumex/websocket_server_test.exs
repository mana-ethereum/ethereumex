defmodule Ethereumex.WebsocketServerTest do
  use ExUnit.Case, async: true
  use Mimic

  import ExUnit.CaptureLog

  alias Ethereumex.WebsocketServer
  alias Ethereumex.WebsocketServer.State

  @valid_request ~s({"jsonrpc": "2.0", "method": "eth_blockNumber", "params": [], "id": "1"})
  @valid_response ~s({"jsonrpc": "2.0", "id": "1", "result": "0x1234"})
  @default_url "ws://localhost:8545"

  setup_all do
    _ = Application.put_env(:ethereumex, :client_type, :websocket)
    _ = Application.put_env(:ethereumex, :websocket_url, @default_url)

    on_exit(fn ->
      _ = Application.put_env(:ethereumex, :client_type, :http)
    end)
  end

  describe "start_link/1" do
    test "starts with default configuration" do
      expect(WebSockex, :start_link, fn @default_url,
                                        WebsocketServer,
                                        %State{url: @default_url},
                                        name: Ethereumex.WebsocketServer,
                                        handle_initial_conn_failure: true ->
        {:ok, self()}
      end)

      assert {:ok, pid} = WebsocketServer.start_link()
      assert is_pid(pid)
    end

    test "starts with custom URL" do
      custom_url = "ws://custom:8545"

      expect(WebSockex, :start_link, fn ^custom_url,
                                        Ethereumex.WebsocketServer,
                                        %State{url: ^custom_url},
                                        name: Ethereumex.WebsocketServer,
                                        handle_initial_conn_failure: true ->
        {:ok, self()}
      end)

      assert {:ok, pid} = WebsocketServer.start_link(url: custom_url)
      assert is_pid(pid)
    end
  end

  describe "handle_connect/2" do
    test "logs connection and returns state unchanged" do
      state = %State{url: "ws://test.com"}

      log =
        capture_log(fn ->
          assert {:ok, ^state} = WebsocketServer.handle_connect(nil, state)
        end)

      assert log =~ "Connected to WebSocket server at ws://test.com"
    end
  end

  describe "handle_cast/2" do
    test "stores request and prepares response" do
      state = %State{url: "ws://test.com", requests: %{}}

      {:reply, {:text, request}, new_state} =
        WebsocketServer.handle_cast({:request, "1", @valid_request, self()}, state)

      assert request == @valid_request
      assert Map.get(new_state.requests, "1") == self()
    end
  end

  describe "handle_frame/2" do
    test "processes valid response and notifies caller" do
      state = %State{
        url: "ws://test.com",
        requests: %{"1" => self()}
      }

      assert {:ok, new_state} = WebsocketServer.handle_frame({:text, @valid_response}, state)
      assert new_state.requests == %{}
      assert_received {:response, "1", "0x1234"}
    end

    test "ignores response with unknown request id" do
      state = %State{url: "ws://test.com", requests: %{}}

      assert {:ok, ^state} =
               WebsocketServer.handle_frame({:text, @valid_response}, state)
    end

    test "handles invalid JSON response" do
      state = %State{url: "ws://test.com", requests: %{}}

      assert {:ok, ^state} =
               WebsocketServer.handle_frame({:text, "invalid json"}, state)
    end

    test "handles response without result" do
      state = %State{url: "ws://test.com", requests: %{}}
      response = ~s({"jsonrpc": "2.0", "id": "1"})

      assert {:ok, ^state} =
               WebsocketServer.handle_frame({:text, response}, state)
    end
  end

  describe "post/1" do
    test "successfully posts request and receives response" do
      test_pid = self()

      expect(WebSockex, :cast, fn Ethereumex.WebsocketServer,
                                  {:request, "1", @valid_request, ^test_pid} ->
        send(test_pid, {:response, "1", "0x1234"})
        :ok
      end)

      assert {:ok, "0x1234"} = WebsocketServer.post(@valid_request)
    end

    test "handles timeout" do
      expect(WebSockex, :cast, fn Ethereumex.WebsocketServer,
                                  {:request, "1", @valid_request, _pid} ->
        :ok
      end)

      assert {:error, :timeout} = WebsocketServer.post(@valid_request)
    end

    test "handles invalid JSON request" do
      assert {:error, %Jason.DecodeError{}} = WebsocketServer.post("invalid json")
    end

    test "handles request without id" do
      request = ~s({"jsonrpc": "2.0", "method": "eth_blockNumber", "params": []})
      assert {:error, :invalid_request_format} = WebsocketServer.post(request)
    end
  end

  describe "reconnection handling" do
    test "resets reconnection attempts after successful connection" do
      state = %WebsocketServer.State{
        url: "ws://localhost:8545",
        reconnect_attempts: 3
      }

      {:ok, new_state} = WebsocketServer.handle_connect(%{}, state)
      assert new_state.reconnect_attempts == 0
    end

    test "does not attempt reconnection for local disconnects" do
      state = %WebsocketServer.State{
        url: "ws://localhost:8545",
        reconnect_attempts: 0
      }

      disconnect_status = %{reason: {:local, :normal}}
      assert {:ok, ^state} = WebsocketServer.handle_disconnect(disconnect_status, state)
    end

    test "attempts reconnection with exponential backoff" do
      state = %WebsocketServer.State{
        url: "ws://localhost:8545",
        reconnect_attempts: 0
      }

      disconnect_status = %{reason: {:remote, :closed}}

      log =
        capture_log(fn ->
          {:reconnect, new_state} = WebsocketServer.handle_disconnect(disconnect_status, state)
          assert new_state.reconnect_attempts == 1
        end)

      assert log =~ "Attempting reconnection 1/5"
    end

    test "stops reconnecting after max attempts" do
      state = %WebsocketServer.State{
        url: "ws://localhost:8545",
        reconnect_attempts: 5
      }

      disconnect_status = %{reason: {:remote, :closed}}

      log =
        capture_log(fn ->
          {:ok, _new_state} = WebsocketServer.handle_disconnect(disconnect_status, state)
        end)

      assert log =~ "Max reconnection attempts (5) reached"
    end

    test "implements exponential backoff delay" do
      state = %WebsocketServer.State{
        url: "ws://localhost:8545",
        reconnect_attempts: 0
      }

      disconnect_status = %{reason: {:remote, :closed}}

      {time, _} =
        :timer.tc(fn ->
          WebsocketServer.handle_disconnect(disconnect_status, state)
        end)

      assert_in_delta time / 1000, 1000, 100
    end
  end
end
