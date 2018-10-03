defmodule Ethereumex.IpcServer do
  use GenServer

  def init(state) do
    path = "/home/hswick/.local/share/io.parity.ethereum/jsonrpc.ipc"
    opts = [:binary, active: false]
    response = :gen_tcp.connect({:local, path}, 0, opts)
    with {:ok, socket} = response do
      {:ok, %{state | socket: socket}}
    else
	{:error, reason} -> {:error, reason}
      e -> {:error, e}
    end
  end  

  def start_link do
    GenServer.start_link(__MODULE__, %{socket: nil}, name: IpcServer)
  end

  def post(request) do
    GenServer.call(IpcServer, {:request, request})
  end

  def handle_call({:request, request}, from, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, request)

    response = :gen_tcp.recv(socket, 0)
    {:reply, response, state}    
  end
end
