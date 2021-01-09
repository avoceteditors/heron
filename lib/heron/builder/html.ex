defmodule Heron.Builder.HTML do

  def run([]) do
    []
  end

  def run([{branch, src, srcs} | rest]) do
    [process(srcs) | run(rest) ]
  end

  def process(srcs) do
    srcs
    |> Enum.each(fn {path, src} ->
      render(srcs, src, src.data)
    end)
  end



  def render(srcs, src, [element | data]) do
  end


end
