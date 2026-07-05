defmodule FileIo.Demo do
  @moduledoc """
  Leitura e escrita de arquivos com `File` e pattern matching em `{:ok, _}` / `{:error, _}`.
  """

  @sample_path Path.expand("../../data/sample.txt", __DIR__)

  @doc """
  Caminho do arquivo de exemplo incluído no projeto.
  """
  def sample_path, do: @sample_path

  @doc """
  Lê o conteúdo do arquivo de exemplo.

  ## Examples

      iex> {:ok, content} = FileIo.Demo.read_sample()
      iex> String.contains?(content, "Elixir")
      true
  """
  def read_sample do
    File.read(@sample_path)
  end

  @doc """
  Escreve texto em um arquivo (sobrescreve o conteúdo existente).

  ## Examples

      iex> path = Path.join(System.tmp_dir!(), "file_io_demo.txt")
      iex> :ok = FileIo.Demo.write_message(path, "teste")
      iex> {:ok, "teste"} = File.read(path)
      iex> File.rm(path)
      :ok
  """
  def write_message(path, message) when is_binary(message) do
    case File.write(path, message) do
      :ok -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Adiciona uma linha ao final de um arquivo.

  ## Examples

      iex> path = Path.join(System.tmp_dir!(), "file_io_append.txt")
      iex> :ok = FileIo.Demo.write_message(path, "linha 1\\n")
      iex> :ok = FileIo.Demo.append_line(path, "linha 2")
      iex> {:ok, content} = File.read(path)
      iex> String.contains?(content, "linha 2")
      true
      iex> File.rm(path)
      :ok
  """
  def append_line(path, line) when is_binary(line) do
    File.write(path, line <> "\n", [:append])
  end

  @doc """
  Conta linhas não vazias de um arquivo.

  ## Examples

      iex> path = Path.join(System.tmp_dir!(), "file_io_count.txt")
      iex> :ok = FileIo.Demo.write_message(path, "a\\nb\\n\\nc")
      iex> FileIo.Demo.count_lines(path)
      3
      iex> File.rm(path)
      :ok
  """
  def count_lines(path) do
    case File.read(path) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> length()

      {:error, _reason} ->
        0
    end
  end
end
