# Game of Stones — Server

Introduces a stateful `GameServer` process that manages a two-player game.

The server holds `{player, stones_count}` as its state and receives `:take` messages to advance turns. It validates moves (1–3 stones, cannot exceed the pile) and determines the winner when the last stone is taken. The server is registered under the name `:game_server` for easy access.

## Files

- `game_of_stones.exs` — `GameServer` module with `start/0`, `listen/1`, and `do_take/1` functions.
