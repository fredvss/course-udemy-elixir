# Game of Stones — GenServer

Full interactive two-player Game of Stones implemented with `GenServer`.

`GameServer` holds the game state (current player and stone count) and handles synchronous calls for querying stats and taking stones. `GameClient` drives the game loop, reads user input, and delegates all state changes to the server. The number of initial stones is configurable.

## Files

- `game_of_stones.exs` — `GameClient` + `GameServer` modules. Run with `elixir game_of_stones.exs` for an interactive session.
