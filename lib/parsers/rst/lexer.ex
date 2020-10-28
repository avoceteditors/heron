defmodule Heron.Parser.RST.Lexer do

  @behaviour Heron.Parser.Lexer

  alias Heron.Parser.Lexer, as: Lexer

  @doc """
  Peforms lexical analysis on a reStructuredText string.
  """
  @impl Heron.Parser.Lexer
  def lex str do
    Lexer.lex_str str
  end

end
