defmodule Ethereumex.IpcServer do
  use GenServer
  @moduledoc false

  def init(state) do
    opts = [:binary, active: false]
    response = :gen_tcp.connect({:local, state[:path]}, 0, opts)

    case response do
      {:ok, socket} -> {:ok, %{state | socket: socket}}
      {:error, reason} -> {:error, reason}
    end
  end

  def start_link(state \\ %{}) do
    GenServer.start_link(__MODULE__, Map.merge(state, %{socket: nil}), name: IpcServer)
  end

  def post(request) do
    GenServer.call(IpcServer, {:request, request})
  end

  def receive_response(data, socket, resukt \\ <<>>)

  def receive_response({:error, reason}, _socket, _result) do
    {:error, reason}
  end

  def receive_response(:ok, socket, result) do
    with {:ok, response} <- :gen_tcp.recv(socket, 0) do
      new_result = result <> response

      if String.ends_with?(response, "\n") do
        {:ok, new_result}
      else
        receive_response(:ok, socket, new_result)
      end
    end
  end

  def receive_response(data, _socket, _result) do
    {:error, data}
  end

  def handle_call({:request, request}, _from, %{socket: socket} = state) do
    response =
      socket
      |> :gen_tcp.send(request)
      |> receive_response(socket)

    {:reply, response, state}
  end
end
