defmodule Ethereumex.HttpClientOptionsTest do
  use ExUnit.Case, async: false

  alias Ethereumex.HttpClient

  @response_delay 200

  setup do
    original = Application.get_env(:ethereumex, :http_options)
    on_exit(fn -> Application.put_env(:ethereumex, :http_options, original) end)

    %{url: start_slow_server(@response_delay)}
  end

  describe "per-request :http_options" do
    test "configured options apply when none are given", %{url: url} do
      Application.put_env(:ethereumex, :http_options, receive_timeout: 50)

      assert {:error, %Finch.TransportError{reason: :timeout}} =
               HttpClient.eth_block_number(url: url)
    end

    test "override the configured options", %{url: url} do
      Application.put_env(:ethereumex, :http_options, receive_timeout: 50)

      assert {:ok, "0x10"} =
               HttpClient.eth_block_number(url: url, http_options: [receive_timeout: 2_000])
    end

    test "can tighten the configured options", %{url: url} do
      Application.put_env(:ethereumex, :http_options, receive_timeout: 2_000)

      assert {:error, %Finch.TransportError{reason: :timeout}} =
               HttpClient.eth_block_number(url: url, http_options: [receive_timeout: 50])
    end

    test "keep configured keys they do not override", %{url: url} do
      Application.put_env(:ethereumex, :http_options, receive_timeout: 50)

      # Overriding only :pool_timeout must not drop the configured
      # :receive_timeout back to Finch's default.
      assert {:error, %Finch.TransportError{reason: :timeout}} =
               HttpClient.eth_block_number(url: url, http_options: [pool_timeout: 5_000])
    end

    test "apply to batch requests", %{url: url} do
      Application.put_env(:ethereumex, :http_options, receive_timeout: 50)

      assert {:ok, [{:ok, "0x10"}]} =
               HttpClient.batch_request([{:eth_block_number, []}],
                 url: url,
                 http_options: [receive_timeout: 2_000]
               )
    end
  end

  # A one-connection-at-a-time HTTP server that answers every request with a
  # fixed JSON-RPC result after `delay` milliseconds.
  defp start_slow_server(delay) do
    {:ok, listen} = :gen_tcp.listen(0, [:binary, active: false, reuseaddr: true])
    {:ok, port} = :inet.port(listen)
    pid = spawn(fn -> accept_loop(listen, delay) end)
    :ok = :gen_tcp.controlling_process(listen, pid)

    on_exit(fn -> Process.exit(pid, :kill) end)

    "http://127.0.0.1:#{port}"
  end

  defp accept_loop(listen, delay) do
    {:ok, socket} = :gen_tcp.accept(listen)
    spawn(fn -> serve(socket, delay) end)
    accept_loop(listen, delay)
  end

  defp serve(socket, delay) do
    case :gen_tcp.recv(socket, 0, 5_000) do
      {:ok, request} ->
        Process.sleep(delay)
        :gen_tcp.send(socket, response(request))
        serve(socket, delay)

      {:error, _closed} ->
        :ok
    end
  end

  defp response(request) do
    body =
      if String.contains?(request, "[{") do
        ~s([{"jsonrpc":"2.0","id":1,"result":"0x10"}])
      else
        ~s({"jsonrpc":"2.0","id":1,"result":"0x10"})
      end

    "HTTP/1.1 200 OK\r\ncontent-type: application/json\r\ncontent-length: #{byte_size(body)}\r\n\r\n" <>
      body
  end
end
