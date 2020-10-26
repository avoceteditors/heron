defmodule Heron do
  @moduledoc """
  Documentation for Heron.
  """
  require Logger

  def server(:start) do
    System.cmd("whoami",[])
  end
end
