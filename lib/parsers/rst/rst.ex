defmodule Heron.Parser.RST do
  alias Heron.Parser.RST.Lexer, as: Lexer

  def parse_string str do
    Lexer.lex str
  end

  def parse_line list do
    "None"
  end
end
