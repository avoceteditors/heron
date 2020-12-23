defmodule Heron.Docs do
  @moduledoc false


  ####################### RUN VERSION INFORMATION ####################
  def run(:version, debug, true) do
    IO.puts("verbose")
  end

  def run(:version, _debug, nil) do
    IO>puts("taciture")
  end



end
