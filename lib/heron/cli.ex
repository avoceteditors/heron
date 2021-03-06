defmodule Heron.CLI do
  @moduledoc false
  require Logger

  def main(argv) do
    argv 
    |> parse 
    |> run

    System.halt(0)
  end

  defp parse(argv) do
    case OptionParser.parse(argv,
      switches: [
        all: :boolean,
        "all-branches": :boolean,
        cache: :string,
        cwd: :string,
        debug: :boolean,
        force: :boolean,
        verbose: :boolean
      ],
      aliases: [
        a: :all,
        A: :"all-branches",
        c: :cache,
        C: :cwd,
        D: :debug,
        f: :force,
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
  defp run({:ok, opts, ["read" | args]}) do
    Logger.info("Called read operation")
    Heron.Reader.run(opts, args)
  end

  defp run({:ok, opts, ["build", build_type, src, output]}) do
    Logger.info("Called build operation")
    Heron.Builder.run(opts, build_type, Heron.Reader.run(opts, [src]), output)
  end
 
  defp run({:ok, opts, ["project" | args]}) do
    Heron.Cache.load_cache(opts[:config], opts[:force])

    Heron.Project.run(opts, args)
  end
  
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
