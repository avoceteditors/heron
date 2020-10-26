defmodule Heron.CLI.Docs do
  @moduledoc """
  Functions provide documentation text for usage output.
  """

  # Metadata
  @name "Heron"
  @byline "The Technical and Fiction Writer's Processing Service"
  @prog "heron"
  @ver "0.1.0"

  ###################### REPORT VERSION ####################
  def version do
    "#{@name} - version #{@ver}"
  end

  def version(:verbose) do
    "#{@name} - #{@byline}\n"
    <> "  Kenneth P. J. Dyer <kenneth@avoceteditors.com>\n"
    <> "  Avocet Editorial Consulting\n"
    <> "  Version #{@ver}\n"
  end

  # Usage Information
  
  @base_usage "#{@prog} [OPTIONS] [COMMANDS]"

  @base_opts """
  OPTIONS:
     -D, --debug   Enables debugging information in log output. 
     -h, --help    Prints base usage information to stdout.
     -v, --verbose Enables verbosity in log output.
  """

  # Comamnd Documentation
  @base_cmds """
  COMMANDS:
     help:         Prints base usage information to stdout.
     version:      Prints version and developer infromation to stdout.
  """

  # Descriptions
  @base_descr """
  DESCRIPTION:
     heron provides a client interface to the Heron Server, an Elixir-based 
     processing service for fiction and technical writers to aid in tracking
     progress, version control, and background typesetting, allowing the writer
     to focus on the text. 
  """

  @doc """
  Returns usage ifnromation from `-h`, `--help` option, and the base `help` subcommand.
  """
  def usage do
    """
    #{@name} - #{@byline}
    #{@base_usage}
    
    #{@base_descr}
    #{@base_opts} 
    #{@base_cmds}
    """
  end


end
