defmodule Heron.Source do

  def read(path, stat, ext) when ext == ".xml" do
    %Heron.Source.XML{path: path, stat: stat, ext: ext}
  end

  def read(path, stat, ext) do
    %Heron.Source.Resource{path: path, stat: stat, ext: ext}
  end
end
