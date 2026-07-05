defmodule Mix.TasksTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "mix hello imprime saudação" do
    output = capture_io(fn -> Mix.Tasks.Hello.run([]) end)
    assert output =~ "Olá do Mix.Task!"
  end

  test "mix greet com nome" do
    output = capture_io(fn -> Mix.Tasks.Greet.run(["Elixir"]) end)
    assert output =~ "Olá, Elixir!"
  end

  test "mix greet --upper" do
    output = capture_io(fn -> Mix.Tasks.Greet.run(["--upper", "elixir"]) end)
    assert output =~ "ELIXIR"
  end

  test "mix stats calcula valores" do
    output = capture_io(fn -> Mix.Tasks.Stats.run(["10", "20", "30"]) end)
    assert output =~ "Soma:   60"
    assert output =~ "Máximo: 30"
  end
end
