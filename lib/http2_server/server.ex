defmodule Http2Server.Server do
  alias Http2Server.Connection, as: Connection
  require Logger

  @doc """
  Starts accepting connections on the given `port`.
  """
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [
      :binary,
      packet: :line,
      active: false,
      reuseaddr: true
    ])
    Logger.info "Accepting connections on port #{port}"
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client_socket} = :gen_tcp.accept(socket)
    Logger.info "Accepting connection from socket"
    {:ok, pid} = Task.Supervisor.start_child(Http2Server.TaskSupervisor, fn ->
      serve(client_socket)
    end)
    :ok = :gen_tcp.controlling_process(client_socket, pid) 
    loop_acceptor(socket)
  end

  defp serve(socket) do
    Logger.info "Serving client socket"
    socket
    |> Connection.preface()
    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(socket, line) do
    :gen_tcp.send(socket, line)
  end
end
