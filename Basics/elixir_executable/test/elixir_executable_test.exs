defmodule ElixirExecutableTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  test "main/1 imprime os argumentos recebidos" do
    output = capture_io(fn -> CLI.main(["foo", "bar"]) end)

    assert output =~ "Argumentos recebidos"
    assert output =~ ~s(["foo", "bar"])
  end
end
