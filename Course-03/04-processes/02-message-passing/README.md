# Message Passing

Demonstrates inter-process communication using `send/2` and `receive/1`.

## Files

- `messages.exs` — Basic message passing: a spawned process waits for a `{sender, {a, b}}` tuple, computes `a * b`, and sends the result back. Includes a `5000ms` timeout with `after`.
- `collect.exs` — Spawns 5 worker processes, sends each a number, and collects all responses using a helper `response/0` function that blocks until each reply arrives.
