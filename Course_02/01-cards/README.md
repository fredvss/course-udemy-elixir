# Cards

A card deck manipulation library that introduces functional programming patterns in Elixir: pure transformations, list operations, Erlang-based binary serialization, and ExDoc documentation.

The library models a standard deck of cards, supporting shuffle, deal, save, and load operations.

## Architecture

All logic lives in a single `Cards` module. There is no mutable state — every function takes a deck and returns a new one.

```
create_deck/0
    |
    v
  ["Ace of Spades", "Two of Spades", ...]   # 20 cards (5 values x 4 suits)
    |
    +-- shuffle/1         ->  randomised deck
    +-- contains?/2       ->  true | false
    +-- deal/2            ->  {hand, remainder}
    +-- save/1            ->  writes binary file to disk
    +-- load/1            ->  reads binary file from disk
    +-- create_hand/2     ->  create -> shuffle -> deal (convenience function)
```

## Module Overview

| Function | Description |
|---|---|
| `create_deck/0` | Generates all 20 cards via a nested comprehension (Cartesian product of values and suits) |
| `shuffle/1` | Randomises card order using `Enum.shuffle/1` |
| `contains?/2` | Returns `true` if a specific card string is in the deck |
| `deal/2` | Splits the deck into `{hand, rest}` using `Enum.split/2` |
| `save/1` | Serialises the deck with `:erlang.term_to_binary/1` and writes to a file |
| `load/1` | Reads and deserialises the deck; returns an error message on missing file |
| `create_hand/2` | Composes `create_deck -> shuffle -> deal` in a single call |

## Concepts Practiced

- List comprehensions with `for` for Cartesian product
- Pipe operator `|>` for composing transformations
- Pattern matching on file read results
- Erlang term binary serialisation (`:erlang.term_to_binary`, `:erlang.binary_to_term`)
- ExDoc documentation with `@doc` and examples

## Running

```elixir
iex -S mix

deck = Cards.create_deck()
deck = Cards.shuffle(deck)
{hand, _rest} = Cards.deal(deck, 5)
IO.inspect(hand)

# Save and reload
Cards.save(deck)
Cards.load("my_deck")
```

## File Format

The saved file is a raw Erlang binary (not human-readable). It is loaded back with `:erlang.binary_to_term/1`. The filename defaults to `"my_deck"`.

