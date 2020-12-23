defmodule Heron.Application do
  use Application

  def start(_type, _arg) do
    children = [

    ]
    opts = [strategy: :one_for_one, name: Heron.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
