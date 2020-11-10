defmodule Heron.Repo.Asana do
  require Logger

  @moduledoc """
  Module runs internal tools to retrieve information on Asana.
  """

  def retrieve do
    case System.cmd("a", ["-l"]) do
      {list, 0} -> retrieve(String.split(list, "\n"))
      _ -> Logger.error("Error retrieving Asana listing")
    end
  end

  def retrieve(list) do
    case list do
      [head | rest] -> [eval(head) | retrieve(rest)]
      _ -> []
    end
  end

  def eval(line) do
    %{
      ticket: fetch(~r{^DOCS-[0-9]+}, line, :none),
      user: Regex.replace(~r{\[}, "", fetch(~r{\S+\.\S+}, line, "none"))
    }
  end

  def fetch(pattern, text, default) do
    ret = Regex.scan(pattern, text, capture: :first)

    if length(ret) > 0 do
      [[first | _] | _] = ret
      first
    else
      default
    end
  end
end
