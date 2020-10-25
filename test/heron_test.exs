defmodule HeronTest do
  use ExUnit.Case
  doctest Heron

  test "greets the world" do
    assert Heron.hello() == :world
  end
end
