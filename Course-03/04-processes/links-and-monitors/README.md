# Links and Monitors

Demonstrates how to handle process failures using links and monitors.

## Files

- `spawn_link.exs` — Uses `spawn_link/1` with `Process.flag(:trap_exit, true)` so the parent process receives an `EXIT` signal (instead of crashing) when the linked child exits with `:error`.
- `monitors.exs` — Uses `spawn_monitor/3` to observe a process without being linked to it. The parent receives a `DOWN` message when the monitored process exits.
