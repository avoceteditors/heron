defmodule Heron.Parser.RST.Lexeme do
  alias Heron.Parser.Grapheme, as: Grapheme

  defstruct type: :text, rawstring: "", indent_level: 0
  alias Heron.Parser.RST.Lexeme, as: Lexeme

  @doc """
  Peforms lexical analysis on a reStructuredText string.
  """
  def lex(str) do
    Grapheme.graph_str(str)
  end

  def lex_line(list, type) do
  end
end
