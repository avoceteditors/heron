defmodule Heron.Parser.RST do
  alias Heron.Parser.RST.Lexeme, as: Lexeme
  require Logger

  def read(path) do
    Logger.debug("Reading reStructuredText File: #{path}")

    case File.read(path) do
      {:ok, text} -> parse(text)
      {:error, _} -> Logger.error("Unable to read file: #{path}")
    end
  end

  def parse(str) do
    parse_lines(Regex.split(~r{\n}, str))
  end

  def parse_lines(list) do
    case list do
      [head | rest] -> [parse_line(String.first(head), head) | parse_lines(rest)]
      _ -> []
    end
  end

  # Parse Headings and Ordered/Unordered Lists
  def parse_line(init, str) when init in ["#"] do
    if String.match?(str, ~r{^###+\s*$}) do
      %Lexeme{type: :h1, rawstring: str}
    else
      parse_line("", str)
    end
  end

  def parse_line(init, str) when init in ["*"] do
    if String.match?(str, ~r{^\*\*\*+\s*$}) do
      %Lexeme{type: :h2, rawstring: str}
    else
      parse_line("", str)
    end
  end

  def parse_line(init, str) when init in ["="] do
    if String.match?(str, ~r{^===+\s*$}) do
      %Lexeme{type: :h3, rawstring: str}
    else
      parse_line("", str)
    end
  end

  def parse_line(init, str) when init in ["-"] do
    if String.match?(str, ~r{^---+\s*$}) do
      %Lexeme{type: :h4, rawstring: str}
    else
      parse_line("", str)
    end
  end

  def parse_line(init, str) when init in ["^"] do
    if String.match?(str, ~r{^\^\^\^+\s*$}) do
      %Lexeme{type: :h5, rawstring: str}
    else
      parse_line("", str)
    end
  end

  def parse_line(init, str) when init in ["\""] do
    if String.match?(str, ~r{^"""+\s*$}) do
      %Lexeme{type: :h6, rawstring: str}
    else
      parse_line("", str)
    end
  end

  def parse_line(init, str) when init in ["."] do
    if String.match?(str, ~r{"^\.\. `"}) do
      %Lexeme{type: :dubdot, rawstring: str}
    else
      parse_line("", str)
    end
  end

  def parse_line(init, str) when init in [" ", "\t"] do
    text = Regex.replace(~r{\t}, str, "   ")
    indent = count_init_ws(String.graphemes(text), 0)
    clean_text = Regex.replace(~r{^\s+}, text, "")

    [
      %Lexeme{type: :indent, rawstring: "", indent_level: indent}
      | parse_line(String.first(clean_text), clean_text)
    ]
  end

  def parse_line(_init, str) do
    Lexeme.lex(str)
  end

  def count_init_ws(list, count) do
    case list do
      [" " | rest] -> count_init_ws(rest, count + 1)
      _ -> count
    end
  end
end
