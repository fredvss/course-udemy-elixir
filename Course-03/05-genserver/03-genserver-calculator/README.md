# GenServer — Calculator

Demonstrates synchronous (`handle_call`) and asynchronous (`handle_cast`) message handling in a `GenServer`, plus the `terminate/2` callback.

Models a simple stateful calculator. Asynchronous operations (`add/1`, `sqrt/0`) update the state via `handle_cast`. The current result is retrieved synchronously via `handle_call`. The server is registered with a name so clients can call it without holding the PID.

## Files

- `calculator.exs` — `GenServer`-based calculator with `handle_call`, `handle_cast`, and `terminate`. Run with `elixir calculator.exs`.
