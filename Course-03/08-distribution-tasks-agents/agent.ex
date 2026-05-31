{:ok, pid} = Agent.start(fn -> 5 end)

Agent.get(pid, fn state -> state end) |> IO.puts

Agent.update(pid, &(&1 * 2))
Agent.get(pid, &(&1)) |> IO.puts
