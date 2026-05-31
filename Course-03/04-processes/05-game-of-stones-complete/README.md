# Game of Stones — Complete

Full interactive two-player Game of Stones with client and server.

Builds on the server-only version by adding a `GameClient` module that handles user input and drives the game loop. The number of initial stones is configurable. The server now also supports an `:info` message to query the current state, and handles the end-game by resetting to the initial state.

## Files

- `game_of_stones.exs` — `GameClient` + `GameServer` modules. Run with `elixir game_of_stones.exs` for an interactive session.
