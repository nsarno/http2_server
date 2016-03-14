defmodule Http2Server.Connection do
  require Logger

  @preface 0x505249202a20485454502f322e300d0a0d0a534d0d0a0d0a

  def preface(socket) do
    :gen_tcp.recv(socket, 24, 30000) |> validate_preface(socket)
  end

  defp validate_preface({:ok, @preface}, socket) do
    Logger.info "Valid preface"
    socket
  end

  defp validate_preface(_invalid, socket) do
    Logger.info "Invalid preface"
    :gen_tcp.close(socket) 
    Process.exit(self, "Invalid preface")
  end
end
