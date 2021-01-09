defmodule Heron.Source.XML do
  require Logger
  require Record

  defstruct path: "", stat: nil, ext: "", data: []

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlNamespace, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  @docbook :"http://docbook.org/ns/docbook"

  defp xpath(nil, _) do
    []
  end

  defp xpath(node, path) do
    :xmerl_xpath.string(to_char_list(path), node)
  end

  def get_attrs(attrs) do
    case attrs do

      [{:xmlAttribute, name, list, nsinfo, olist, parent, pos, edef, value, b}| rest] ->
        if String.match?(Atom.to_string(name), ~r/^xmlns/) or name in [:version] do
          get_attrs(rest)
        else
          key = case name do
            :"xml:id" -> :id
            :"dion:ctime" -> :ctime
            :"dion:status" -> :status
            _ -> name
          end
          [[key, value] | get_attrs(rest)]
        end
      [] -> []
    end

  end

  def render(source, []) do
    []
  end
  def render(source, nil) do
    [] 
  end


  def render(source, [{:xmlElement, name, expanded_name, nsinfo, {:xmlNamespace, ns, nsl}, parents, pos, base_attrs, base_content, language, xmlbase, elementdef} | rest]) do

    attrs = get_attrs(base_attrs)
    |> Map.new(fn [k,v] -> {k, v} end)

    [%Heron.Element{name: name, id: Map.get(attrs, :id, nil), role: Map.get(attrs, :role, nil), attrs: attrs, content:  render(source, base_content), parents: parents} | render(source, rest)]

  end

  def render(source, [{:xmlText, parent, pos, thing, value, :text} | rest]) do
    [%Heron.Text{content: value} | render(source, rest)]
  end

  def render(source, [{:xmlComment, parent, pos, thing, text} | rest]) do
    render(source, rest)
  end




  def process(source, root) do
    Map.put(source, :data, render(source, xpath(root, "/*")))
  end

end
