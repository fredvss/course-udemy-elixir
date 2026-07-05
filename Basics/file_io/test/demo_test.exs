defmodule FileIo.DemoTest do
  use ExUnit.Case, async: true
  doctest FileIo.Demo

  setup do
    path = Path.join(System.tmp_dir!(), "file_io_test_#{:erlang.unique_integer([:positive])}.txt")
    on_exit(fn -> File.rm(path) end)
    {:ok, path: path}
  end

  test "read_sample/0 lê o arquivo de exemplo", %{path: _path} do
    assert {:ok, content} = FileIo.Demo.read_sample()
    assert String.contains?(content, "Elixir")
  end

  test "write_message/2 e append_line/2", %{path: path} do
    assert :ok = FileIo.Demo.write_message(path, "primeira")
    assert :ok = FileIo.Demo.append_line(path, "segunda")

    assert {:ok, content} = File.read(path)
    assert content =~ "primeira"
    assert content =~ "segunda"
  end

  test "count_lines/1 ignora linhas vazias", %{path: path} do
    :ok = FileIo.Demo.write_message(path, "a\n\nb\n")
    assert FileIo.Demo.count_lines(path) == 2
  end
end
