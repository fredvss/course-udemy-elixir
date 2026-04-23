# ExMon

A turn-based battle game inspired by Pokémon, built to demonstrate OTP Agents, struct-based domain modeling, and modular action dispatch in Elixir.

Two players fight each other by selecting moves each turn. Each player has 100 HP, three moves (two attacks and one heal), and loses when their HP reaches 0. After the player acts, the computer takes its own turn with a randomly selected move.

## Architecture

```
ExMon (public API)
  |
  +-- create_player/4       -> %Player{}
  +-- start_game/1          -> ExMon.Game (Agent)
  +-- make_move/1
        |
        +-- ExMon.Game.Actions.fetch_move/2
              |
              +-- :move_rnd / :move_avg  -> Attack.attack_opponent/2
              +-- :move_heal             -> Heal.heal_life/1
              |
              v
        ExMon.Game.update/1  (Agent state update)
              |
        ExMon.Game.Status.print_round_result/1
              |
        check game over / computer turn
```

## Module Overview

| Module | Responsibility |
|---|---|
| `ExMon` | Public API: player creation, game start, move dispatch |
| `ExMon.Player` | Struct: `name`, `life` (100), `moves` map |
| `ExMon.Game` | OTP Agent holding the current game state |
| `ExMon.Game.Actions` | Dispatches moves to Attack or Heal |
| `ExMon.Game.Actions.Attack` | Calculates and applies damage (18–35 HP random range) |
| `ExMon.Game.Actions.Heal` | Restores HP (18–25 HP, capped at 100) |
| `ExMon.Game.Status` | Prints round results, game over, and win messages |

## Player Struct

```elixir
%ExMon.Player{
  name: "Pikachu",
  life: 100,
  moves: %{
    move_rnd: :thunderbolt,   # high damage
    move_avg: :tackle,        # medium damage
    move_heal: :potion        # restore HP
  }
}
```

## Game State

The Agent stores a map with the current state of both players and whose turn it is:

```elixir
%{
  player: %Player{},
  computer: %Player{},
  turn: :player | :computer,
  status: :started | :game_over
}
```

## Concepts Practiced

- OTP `Agent` for maintaining mutable state across function calls
- Struct definitions and usage
- Pattern matching for control flow
- Randomised damage with `Enum.random/1`
- Modular design with distinct action modules

## Running

```elixir
iex -S mix

player = ExMon.create_player("Ash", :thunderbolt, :tackle, :potion)
ExMon.start_game(player)
ExMon.make_move(:move_rnd)
ExMon.make_move(:move_heal)
```

