defmodule FizzBuzz do
  # primeira versao
  # def build(file_name) do
  #   case File.read(file_name) do
  #     {:ok, result} -> result
  #     {:error, reason} -> reason
  #   end
  # end

  # segunda versao
  # def build(file_name) do
  #   file = File.read(file_name)
  #   handle_file_read(file)
  # end

  # def handle_file_read({:ok, result}), do: result
  # def handle_file_read({:error, reason}), do: reason

  # terceira versao
  def build(file_name) do
    file_name
    |> File.read()
    |> handle_file_read()
  end

  defp handle_file_read({:ok, result}) do
    result =
      result
      |> String.split(",")
      |> Enum.map(fn element -> convert_and_evaluate_numbers(element) end)

    {:ok, result}
    # outra maneira - sem criar func anonima
    # result
    # |> String.split(",")
    # |> Enum.map(&String.to_integer/1)
  end

  defp handle_file_read({:error, reason}), do: {:error, "Error reading the file: #{reason}"}

  defp convert_and_evaluate_numbers(element) do
    element
    |> String.to_integer()
    |> evaluate_numbers()
  end

  # Pattern matching é sequencial e não valida as demais condições uma vez que deu match
  defp evaluate_numbers(number) when rem(number, 3) == 0 and rem(number, 5) == 0, do: :fizzbuzz
  defp evaluate_numbers(number) when rem(number, 3) == 0, do: :fizz
  defp evaluate_numbers(number) when rem(number, 5) == 0, do: :buzz
  defp evaluate_numbers(number), do: number
end
