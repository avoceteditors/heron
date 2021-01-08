defmodule Heron.Source.XML do
  require Logger
  require Record

  defstruct path: "", stat: nil, ext: "", data: []

  Record.defrecord :xmlElement, Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlNamespace, Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  @docbook :"http://docbook.org/ns/docbook"

  defp xpath(nil, _) do
    []
  end

  defp xpath(node, path) do
    :xmerl_xpath.string(to_char_list(path), node)
  end

  def render_content(source, content) do
    case content do
      [element | rest] ->
    end
  end

  def render(source, [{:xmlElement, name, expanded_name, nsinfo, {:xmlNamespace, ns, nsl}, parents, pos, attrs, content, language, xmlbase, elementdef}]) do
    IO.inspect name
  end


  def render(source, [element]) do
    #IO.puts "New Render\n\n\n"
    #IO.inspect xmlElement(element)
    source
  end


  def process(source, root) do
    Map.put(source, :content, render(source, xpath(root, "/*")))
    source
  end
#  {{xmlElement,motorcycles,
#             motorcycles,
#             [],
#             {xmlNamespace,[],[]},
#             [],
#             1,
#             [],
#             [{xmlText,[{motorcycles,1}],1,[],"\
#  ",text},
#              {xmlElement,bike,
#                          bike,
#                          [],
#                          {xmlNamespace,[],[]},
#                          [{motorcycles,1}],
#                          2,
#                          [{xmlAttribute,year,[],[],[],[]|...},
#                           {xmlAttribute,color,[],[],[]|...}],
#                          [{xmlText,[{bike,2},{motorcycles|...}],
#                                    1,
#                                    []|...},
#                           {xmlElement,name,name,[]|...},
#                           {xmlText,[{...}|...],3|...},
#                           {xmlElement,engine|...},
#                           {xmlText|...},
#                           {...}|...],
#                          [],
#                          ".",
#                          undeclared},
#              ...
#              ],
#             [],
#             ".",
#             undeclared},
# []}
end
