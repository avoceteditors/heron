defmodule Heron.Parser.Grapheme do
  @moduledoc """
  Functions used in graphical analysis, replacing the given string with a list
  of strings and graphemes.
  """
  defstruct type: :text, rawstring: ""

  alias Heron.Parser.Grapheme, as: Grapheme

  def graph_str(str) do
    String.graphemes(str) |> graph_list |> concat_graphemes
  end

  def graph_list(list) do
    case list do
      [head | rest] -> [graph_char(head) | graph_list(rest)]
      _ -> []
    end
  end

  ################################# GRAPH CHARACTERS #################################
  @doc """
  Catagorizes graphemes by lexically significant types.
  """

  # WhiteSpace Matching
  def graph_char(str) when str == " " do
    %Grapheme{type: :ws, rawstring: str}
  end

  def graph_char(str) when str == "\t" do
    %Grapheme{type: :ws, rawstring: "   "}
  end

  # Brace and Bracket Match
  def graph_char(str) when str in ["[", "{", "(", "<", ">", ")", "}", "]"] do
    case str do
      "[" -> %Grapheme{type: :obracket, rawstring: str}
      "{" -> %Grapheme{type: :obrace, rawstring: str}
      "(" -> %Grapheme{type: :oparen, rawstring: str}
      "<" -> %Grapheme{type: :oangbrack, rawstring: str}
      ">" -> %Grapheme{type: :cangbrack, rawstring: str}
      ")" -> %Grapheme{type: :cparen, rawstring: str}
      "}" -> %Grapheme{type: :cbrace, rawstring: str}
      "]" -> %Grapheme{type: :cbracket, rawstring: str}
    end
  end

  # Inline Markup match
  def graph_char(str) when str in ["*", "'", "\"", "_", "`"] do
    case str do
      "*" -> %Grapheme{type: :asterisk, rawstring: str}
      "'" -> %Grapheme{type: :tick, rawstring: str}
      "\"" -> %Grapheme{type: :quote, rawstring: str}
      "_" -> %Grapheme{type: :underscore, rawstring: str}
      "`" -> %Grapheme{type: :btick, rawstring: str}
    end
  end

  # Punctation Marks
  def graph_char(str)
      when str in [
             "!",
             "@",
             "#",
             "$",
             "%",
             "^",
             "&",
             "-",
             "=",
             "+",
             "\\",
             "/",
             "|",
             ",",
             ".",
             "~",
             ":",
             ";"
           ] do
    case str do
      "!" -> %Grapheme{type: :exclam, rawstring: str}
      "@" -> %Grapheme{type: :atsign, rawstring: str}
      "#" -> %Grapheme{type: :hash, rawstring: str}
      "$" -> %Grapheme{type: :doll, rawstring: str}
      "%" -> %Grapheme{type: :perc, rawstring: str}
      "^" -> %Grapheme{type: :caret, rawstring: str}
      "&" -> %Grapheme{type: :amp, rawstring: str}
      "-" -> %Grapheme{type: :dash, rawstring: str}
      "=" -> %Grapheme{type: :eq, rawstring: str}
      "+" -> %Grapheme{type: :plus, rawstring: str}
      "\\" -> %Grapheme{type: :bslash, rawstring: str}
      "/" -> %Grapheme{type: :fslash, rawstring: str}
      "|" -> %Grapheme{type: :pipe, rawstring: str}
      "," -> %Grapheme{type: :comma, rawstring: str}
      "." -> %Grapheme{type: :period, rawstring: str}
      "~" -> %Grapheme{type: :tilda, rawstring: str}
      ":" -> %Grapheme{type: :colon, rawstring: str}
      ";" -> %Grapheme{type: :semicolon, rawstring: str}
    end
  end

  # Numerals
  def graph_char(str) when str in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] do
    %Grapheme{type: :num, rawstring: str}
  end

  # Default Match to Text
  def graph_char(str) do
    %Grapheme{type: :text, rawstring: str}
  end

  ############################# CONCATENATE NON-SIGNIFICANT GRAPHEMES ##################
  def concat_graphemes(list) do
    case list do
      [head | rest] ->
        if head.type in [:text, :ws, :num] do
          concat_str(head, rest)
        else
          [head | concat_graphemes(rest)]
        end

      [] ->
        []
    end
  end

  def concat_str(base, list) do
    case list do
      [head | rest] ->
        if base.type == head.type do
          concat_str(
            %Grapheme{type: base.type, rawstring: base.rawstring <> head.rawstring},
            rest
          )
        else
          [base | concat_graphemes(list)]
        end

      [] ->
        [base]
    end
  end
end
