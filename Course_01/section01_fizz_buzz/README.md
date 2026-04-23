# FizzBuzz

An implementation of the classic FizzBuzz problem in Elixir, used as a hands-on introduction to the language's core features: pattern matching, guard clauses, the pipe operator, and file I/O.

The program reads a file containing a comma-separated list of integers and transforms each value according to the FizzBuzz rules, returning a list of atoms or numbers.

## Architecture

```
numbers.txt
    |
    v
FizzBuzz.build/1
    |
    +-- File.read/1
    |       |
    |   handle_file_read/1  -- error tuple -> print error
    |       |
    |   convert_and_evaluate_numbers/1
    |       |
    |   String.split -> Enum.map -> evaluate_numbers/1
    |                                   |
    |                               pattern match with guards
    |                               :fizz | :buzz | :fizzbuzz | n
    |
    v
  [result list]
```

## Module Overview

### `FizzBuzz`

| Function | Description |
|---|---|
| `build/1` | Entry point. Reads a file and returns the evaluated list. |
| `handle_file_read/1` | Pattern-matches `{:ok, body}` or `{:error, reason}`. |
| `convert_and_evaluate_numbers/1` | Splits the file string, converts to integers, and maps over `evaluate_numbers/1`. |
| `evaluate_numbers/1` | Returns `:fizzbuzz`, `:fizz`, `:buzz`, or the number itself using guards. |

## Concepts Practiced

- Pattern matching with guard clauses (`rem(n, 3) == 0`)
- The pipe operator `|>` for composing transformations
- Error handling with tagged tuples `{:ok, value}` / `{:error, reason}`
- File reading with `File.read/1`
- `Enum.map/2` and `String.split/2`

## Running

```bash
mix test
```

Or in IEx:

```elixir
iex -S mix
FizzBuzz.build("numbers.txt")
# => [1, 2, :fizz, 4, :buzz, :fizz, 7, 8, :fizz, :buzz, ...]
```

## Input Format

The `numbers.txt` file must contain a single line of comma-separated integers:

```
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
```

