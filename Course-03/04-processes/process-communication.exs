defmodule Demo do
  def work() do
    IO.puts("Doing the work...")

    receive do
      message ->
        IO.puts("Received message: #{message}")
    end
  end

  def run(message) do
    pid = spawn fn ->
      work()
    end

    send(pid, message)
  end
end

Demo.run("Hello")
IO.puts("Executing the module...")


defmodule DemoResponse do
  def work() do
    IO.puts("Doing the response work...")

    receive do
      {sender, message} ->
        IO.puts("Received message: #{message}")
        send(sender, {:ok, "Message received"})
    end
  end

  def run(message) do
    pid = spawn fn ->
      work()
    end

    send(pid, {self(), message})

    receive do
      {:ok, response} ->
        IO.puts("Received response: #{response}")
    end
  end
end

IO.puts("================================")

IO.puts("Executing the module and waiting the process response...")
DemoResponse.run("Random message")
