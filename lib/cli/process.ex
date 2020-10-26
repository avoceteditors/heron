defmodule Heron.CLI.Process do

  # External Modules 
  require Logger


  ########################### VERSION FUNCTONS ##############################
  @doc """
  Function reports version information
  """
  def run({:version, verbose}) do
    if verbose do
      IO.puts(Heron.CLI.Docs.version(:verbose))
    else
      IO.puts(Heron.CLI.Docs.version)
    end
  end

  ########################### HELP FUNCTONS ##############################
  @doc """
  Function used to print usage information.
  """
  def run({:help}) do
    IO.puts(Heron.CLI.Docs.usage)
  end


  ######################### ERROR HANDLING ###############################

  @doc """
  Function used to print usage information in the event of errors.
  """
  def run({:help_badopts, badopts}) do
    IO.puts("Print usage on error")
  end

  def run({:err, msg}) do
    Logger.info(msg)
  end


  ######################### SERVER COMMANDS ##############################
  @service "#{System.get_env("HERON_SERVER")}"

  def run({:server, :schema}) do
    Logger.info("Called server operation")
  end

  def run({:server, :init}) do
    Logger.info("Initializing Server")
    System.cmd(@service, ["start"])
  end

  def run({:server, :start}) do
    Logger.info("Starting Server")
    Node.connect(:heron@hephaistion)
    Heron.Server.start_link
  end

  def run({:server, :stop}) do
    Logger.info("Stopping server")
    System.cmd(@service, ["stop"])
  end





end
