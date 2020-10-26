defmodule Heron.Server do
  @moduledoc """
  Server module providing Client APi and back-end server 
  """
  use GenServer
  require Logger

  # Client API
  def start_link do
    Logger.info("Starting Server")
    GenServer.start_link(:heron, [])
  end

  def stop do
    Logger.info("Stoping Server")
    :mnesia.stop
    GenServer.call(:heron, :stop)
  end

  def schema do
    Logger.info("Refactoring Database Schema")
    Logger.debug("Deleting Schema :heron")
    :mnesia.delete_schema(:heron)

    Logger.debug("Creating schema :heron")
    :mnesia.create_schema(:heron)
  end


  # Server Call Backs
  def init(data) do
    Logger.warn("TEST")
    {:ok, data}
  end

  # Start Server
  def handler_cast(:start, data) do
    {:ok, data}
  end

  def handler_call(:stop, data) do
    {:ok, data}
  end

end
