defmodule Demo do
  def work(number, index) do
    pid = spawn(fn ->
      :timer.sleep(5000)
      IO.puts("#{index} - Working on #{Float.round(:rand.normal() * number, 2)}")
    end)
    pid |> IO.inspect()
  end

  def run(number) do
    Enum.each(1..number, &work(number, &1))
  end
end

Demo.run(2)
IO.puts("Another work...")
