# GenServer — Init Validation

Demonstrates input validation inside the `init/1` callback using guard clauses.

The server only starts successfully when the initial state is a number. Any other value causes the process to stop with a descriptive error. Introduces the pattern of wrapping `GenServer.start/2` in a named interface function (`start/1`).

## Files

- `genserver_init_validation.exs` — `GenServer` with guarded `init/1` that rejects non-numeric initial state. Run with `elixir genserver_init_validation.exs`.
