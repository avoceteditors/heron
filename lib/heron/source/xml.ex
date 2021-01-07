defmodule Heron.Source.XML do
  defstruct path: "", stat: nil, ext: "", data: []

  def render(root) do
    IO.inspect root
  end
  {{xmlElement,motorcycles,
             motorcycles,
             [],
             {xmlNamespace,[],[]},
             [],
             1,
             [],
             [{xmlText,[{motorcycles,1}],1,[],"\
  ",text},
              {xmlElement,bike,
                          bike,
                          [],
                          {xmlNamespace,[],[]},
                          [{motorcycles,1}],
                          2,
                          [{xmlAttribute,year,[],[],[],[]|...},
                           {xmlAttribute,color,[],[],[]|...}],
                          [{xmlText,[{bike,2},{motorcycles|...}],
                                    1,
                                    []|...},
                           {xmlElement,name,name,[]|...},
                           {xmlText,[{...}|...],3|...},
                           {xmlElement,engine|...},
                           {xmlText|...},
                           {...}|...],
                          [],
                          ".",
                          undeclared},
              ...
              ],
             [],
             ".",
             undeclared},
 []}
end
