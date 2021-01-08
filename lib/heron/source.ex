defmodule Heron.Source do

  def read(path, stat, ext) when ext == ".xml" do
    {root, _} = :xmerl_scan.file(path)
    source = %Heron.Source.XML{path: path, stat: stat, ext: ext}
    Heron.Source.XML.process(source, root)
  end

  def read(path, stat, ext) do
    %Heron.Source.Resource{path: path, stat: stat, ext: ext}
  end
end
