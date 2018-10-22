defmodule Ethereumex.WebSocketServer do
  require Logger
  use WebSockex
  @moduledoc false

  def start_link(url, state \\ %{requests: %{}, subscriptions: %{}}) do
    WebSockex.start_link(url, __MODULE__, state, name: WebSocketServer)
  end

  def subscribe(subscription_id) do
    GenServer.cast(WebSocketServer, {:subscribe, subscription_id, self()})
  end

  def send_message(message, request_id) do
    GenServer.cast(WebSocketServer, {:subscribe_once, request_id, self()})
    WebSockex.send_frame(WebSocketServer, {:text, message})

    receive do
      decoded_message -> decoded_message
    end
  end

  def handle_frame({:text, message}, state) do
    decoded_message = Poison.decode!(message)

    if decoded_message["method"] == "eth_subscription" do
      send(
        state[:subscriptions][decoded_message["params"]["subscription"]],
        decoded_message["params"]["result"]
      )
    else
      send(state[:requests][decoded_message["id"]], decoded_message)
    end

    {:ok, state}
  end

  def handle_info({:"$gen_cast", {:subscribe, subscription_id, pid}}, state) do
    state = put_in(state, [:subscriptions, subscription_id], pid)
    {:ok, state}
  end

  def handle_info({:"$gen_cast", {:subscribe_once, request_id, pid}}, state) do
    state = put_in(state, [:requests, request_id], pid)
    {:ok, state}
  end
end
