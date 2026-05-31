defmodule Demo do
  def work do
    :timer.sleep(3000)
    IO.puts("Work done by #{inspect(self())}")
  end
end


worker = Task.async(fn -> Demo.work() end)
IO.puts("Doing other work in the main process...")

answer = Task.await(worker)
IO.puts("The answer is: #{inspect(answer)}")
