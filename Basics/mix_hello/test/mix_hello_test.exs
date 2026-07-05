defmodule MixHelloTest do
  use ExUnit.Case, async: true
  doctest MixHello

  test "greet/1 com nome customizado" do
    assert MixHello.greet("Ana") == "Olá, Ana!"
  end
end
