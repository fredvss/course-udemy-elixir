# Identicon

Generates deterministic visual identicons from text input. The same string always produces the same 250x250 pixel PNG image, making it useful for avatar generation based on usernames or other identifiers.

The implementation demonstrates a pure data-transformation pipeline using Elixir structs, MD5 hashing via Erlang's `:crypto` module, and image rendering via `:egd`.

## Pipeline

```
input string
    |
    v
hash_input/1       -- MD5 via :crypto.hash -> list of 16 integers
    |
    v
pick_color/1       -- first 3 bytes become {r, g, b}
    |
    v
build_grid/1       -- arrange into 5x5 grid, mirror each row (col 4 = col 2, col 5 = col 1)
    |
    v
filter_odd_squares/1  -- keep only cells with even values (the coloured squares)
    |
    v
build_pixel_map/1  -- convert grid index to pixel coordinates (each cell = 50x50 px)
    |
    v
draw_image/1       -- render pixels with :egd using the picked colour
    |
    v
save_image/2       -- write PNG file to disk
```

## Data Structure

A single struct accumulates data through the pipeline:

```elixir
%Identicon.Image{
  hex:       [int, ...],            # 16 MD5 bytes
  color:     {r, g, b},             # RGB tuple
  grid:      [{value, index}, ...], # 25 cells
  pixel_map: [{{x1,y1}, {x2,y2}}, ...] # 25 coordinate pairs
}
```

## Image Layout

- Output size: 250x250 pixels
- Grid: 5 columns x 5 rows, each cell is 50x50 px
- Symmetry: the grid is horizontally mirrored (only 3 unique columns)
- Coloring: cells with even hash values are filled; odd cells are white

## Concepts Practiced

- Pipeline architecture with `|>` and struct accumulation
- Erlang interop: `:crypto`, `:egd`, `:erlang.binary`
- List chunking with `Enum.chunk_every/2`
- Index-based coordinate math
- Deterministic output from hash functions

## Running

```elixir
iex -S mix

Identicon.main("banana")
# => writes "banana.png" to the current directory
```

> Note: `:egd` is deprecated in modern OTP versions. The project was developed for learning purposes and may require an older OTP release or a compatible `:egd` installation.

