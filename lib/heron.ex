defmodule Heron do
  @moduledoc """
  Heron functions for common operations.
  """
  require Logger

  def server(:start) do
    System.cmd("whoami", [])
  end

  def read(path) do
    case Path.extname(path) do
      ".rst" -> Heron.Parser.RST.read(path)
      ext -> Logger.error("Unknown extension type: #{ext}")
    end
  end

  def get_ext(path) do
    ext = Path.extname(path)
    cond do
      ext in [".xml", ".docbook", ".dion"] -> :xml
      ext in [".rst", ".resturcutredtext"] -> :rst
      ext in [".md", ".markdown"] -> :md
      true -> :resource
    end
  end

end

