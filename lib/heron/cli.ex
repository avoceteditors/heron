defmodule Heron.CLI do
  @moduledoc false
  require Logger

  def main(argv) do
    argv 
    |> parse 
    |> run
  end

  defp parse(argv) do
    case OptionParser.parse(argv,
      switches: [
        debug: :boolean,
        verbose: :boolean
      ],
      aliases: [
        D: :debug,
        v: :verbose
      ]) do

      {opts, args, []} -> {:ok, opts, args}
      {_, args, bad} -> {:error, bad, args}
    end
  end

  defp process({:ok, opts, args}) do

    # Configure Logger
    case [opts[:debug], opts[:verbose]] do
      [true, _] -> Logger.configure(level: :debug)
      [nil, true] -> Logger.configure(level: :info)
      [nil, nil] -> Logger.configure(level: :error)
    end

    {opts, args}
  end

  defp process({:error, bad, args}) do
    Logger.error("Invalid Options: #{IO.inspect bad}")
    System.halt(1)
  end

  ####################### RUN HERON ############################
  
  defp run({:ok, opts, ["help" | args]}) do
    Heron.Docs.run(:help, args)
  end

  defp run({:ok, opts, ["version" | args]}) do
    Heron.Docs.run(:version, opts[:debug], opts[:verbose])
  end

  defp run({:ok, opts, [cmd | args]}) do
    Logger.error "Unknown Command: #{cmd}"
    Heron.Docs.run(:help, [])
  end

  defp run({:ok, opts, []}) do
    run({:ok, opts, ["version"]})
  end

end