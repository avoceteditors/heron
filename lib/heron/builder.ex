defmodule Heron.Builder do
  require Logger

  def run(opts, "html", srcs, output) do
    Logger.debug("Building HTML website")
    Heron.Builder.HTML.run(srcs)
  end

  def run(_opts, build_type, _srcs, _output) do
    Logger.warn("Unknown or invalid build type: #{build_type}")
    System.halt(1)
  end
end
