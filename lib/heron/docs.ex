defmodule Heron.Docs do
  @moduledoc false


  ####################### RUN VERSION INFORMATION ####################
  
  @prog "heron"
  @title String.capitalize(@prog)
  @byline "The Document Processor"
  @author "Kenneth P. J. Dyer <kenneth@avoceteditors.com>"
  @comp "Avocet Editorial Consulting"

  def version_data(true) do
    [
      "#{@title} - #{@byline}",
      @author,
      @comp,
      "Version #{Application.spec(:heron, :vsn)}"
    ]
  end

  def version_data(nil) do
    [
      "#{@prog} - version #{Application.spec(:heron, :vsn)}"
    ]
  end

  def build_data(true) do
    [
      "Elixir version #{System.build_info[:version]}",
      "OTP release #{System.build_info[:otp_release]}"
    ]
  end

  def build_data(nil) do
    []
  end

  def run(:version, debug, verbose) do
    version_data(verbose) ++ build_data(debug)
    |> Enum.join("\n  ")
    |> IO.puts
  end

  ####################### USAGE INFORMATION ######################

  # Options
  defp get_options do
    [
      "-D, --debug     Enables logging with debugging messages.",
      "-v, --verbose   Enables logging with verbose messages." 
    ]
    |> Enum.sort 
  end

  defp usage do

  end

  defp options do
    ["\nOptions:"] 
    ++ get_options
    |> Enum.join("\n  ")
  end

  defp docs([]) do
    [
      "\nDocument processor, used to process a collection of XML files,",
      "analyzing content, reporting statistics, rendering to HTML or PDF."
    ]
    |> Enum.join("\n")
  end

  defp docs(args) do
    [docs([])]
    |> Enum.join("\n")
  end

  ############################ COMMANDS ###########################
  
  # Read Command
  
  @help_cmd {
    "help         ",
    ["Provides usage documentation for the application."]
  }
  # Version Command
  @version_cmd {
    "version      ",
    ["Returns the current version of the application."]
  }

  defp get_commands([]) do
    [@version_cmd, @help_cmd]
    |> Enum.map(fn {cmd, docs} ->
      "#{cmd}   #{Enum.join(docs, "\n      ")}"
        end)
    |> Enum.sort
  end

  defp commands(args) do
    ["\nCommands:"]
    ++ get_commands(args)
    |> Enum.join("\n  ")
  end

  def run(:help, args) do
    [
      "Usage: #{@prog} [OPTIONS] COMMANDS",
      docs(args),
      options(),
      commands(args),
    ]
    |> Enum.join("\n")
    |> IO.puts
  end

  
end
