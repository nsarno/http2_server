defmodule Http2Server do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Task.Supervisor, [[name: Http2Server.TaskSupervisor]]),
      worker(Task, [Http2Server.Server, :accept, [4040]])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Http2Server.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
