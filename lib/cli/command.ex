defmodule Heron.CLI do
  @moduledoc """
  Command-line specifications for the Heron Client.  These commands are run by `heron` escript binary,
  they generally require a running `heron-server`.
  """

  @doc """
  Main process function
  """
  def main(args) do
    args |> run_options |> Heron.CLI.Process.run
  end

  @doc """
  Function configures and processes command-line options and arguments
  """
  def run_options(args) do

    # Configure Options and Arguments
    cmd_opts = OptionParser.parse(args,
      switches: [
        debug: :boolean,
        help: :boolean,
        verbose: :boolean,
      ],
      aliases: [
        D: :debug,
        h: :help,
        v: :verbose
      ]
    )

    # Evaluate Options and Arugments
    case cmd_opts do

      # Help
      {[help: true], _, _} -> {:help}
      {opts, args, []} -> case args do
        # Help Command 
        ["help"| _] -> {:help}

        # Server Commands
        ["server" | svr_cmds] -> case svr_cmds do 

          # Print Server Help
          ["help"| _] -> {:help, :server}

          ["init"| _] -> {:server, :init}

          ["schema"] -> {:server, :schema}

          ["start"] -> {:server, :start} 

          ["stop"] -> {:server, :stop}

          _ -> {:err, "Unknown Server Command ${svr_cmds}"}
        end

        # Version 
        ["version"| _] -> {:version, opts[:verbose]}
        _ -> {:err, "Invalid Comamnd: #{args}"}
      end
      {_, _, bad_opts} -> {:help_badopts, bad_opts}
    end
  end
end
