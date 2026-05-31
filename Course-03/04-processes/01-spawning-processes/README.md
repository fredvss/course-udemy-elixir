# Spawning Processes

Demonstrates how to spawn concurrent processes in Elixir using `spawn/1`.

Each spawned process performs work asynchronously (simulated with `:timer.sleep/1`) and prints a result using `:rand.normal/0`. The parent process continues executing immediately after spawning, showing that processes run concurrently.

## Files

- `processes.exs` — Spawns 5 worker processes and prints their PIDs and results.
