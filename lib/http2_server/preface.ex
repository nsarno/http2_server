defmodule Http2Server.Preface do
  require Logger

  @preface "PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n"
  @preface_length 24
  @timeout 30000

  def validate(socket) do
    {:ok, packet} = :gen_tcp.recv(socket, @preface_length, @timeout)
    validate(socket, packet)   
  end

  defp validate(socket, @preface) do
    Logger.info "Preface: 👍"
    socket
  end

  defp validate(socket, _) do
    Logger.info "Preface: 👎"
    :gen_tcp.close(socket) 
    Process.exit(self, "Invalid preface")
  end
end
