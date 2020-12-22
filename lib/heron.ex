defmodule Heron do
  @moduledoc """
  Heron functions for common operations.
  """
  require Logger

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

