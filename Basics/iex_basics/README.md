# IEx Basics — Scripts interativos

Coleção de scripts `.exs` para explorar Elixir no **IEx** (Interactive Elixir) ou com `elixir script.exs`. Ideal como primeiro contato com a linguagem, antes de projetos Mix completos.

## Conceitos

- Tipos básicos: inteiros, floats, atoms, strings, listas, tuplas e mapas
- Pattern matching com `=`
- Pipe operator `|>`
- Funções anônimas e captura `&`
- Comandos do IEx: `h/1`, `i/1`, `c/1`

## Como usar

### Opção 1 — Carregar no IEx

```bash
cd Basics/iex_basics
iex
```

Dentro do IEx:

```elixir
# Carregar um script (executa e mantém bindings)
import_file("01_types.exs")

# Ajuda sobre uma função
h String.upcase/1

# Informações sobre um valor
i "hello"
```

### Opção 2 — Executar como script

```bash
elixir 01_types.exs
elixir 02_pattern_matching.exs
elixir 03_pipe.exs
elixir 04_help_and_info.exs
```

## Scripts

| Arquivo | Tema |
|---------|------|
| [01_types.exs](01_types.exs) | Tipos nativos e inspeção com `IO.inspect/2` |
| [02_pattern_matching.exs](02_pattern_matching.exs) | Matching em listas, tuplas e mapas |
| [03_pipe.exs](03_pipe.exs) | Composição com `\|>` e `Enum` |
| [04_help_and_info.exs](04_help_and_info.exs) | Dicas de exploração no IEx |

## Ordem sugerida

```text
01_types.exs  →  02_pattern_matching.exs  →  03_pipe.exs  →  04_help_and_info.exs
```

## Próximos passos

- [mix_hello](../mix_hello/) — primeiro projeto Mix com testes
- [elixir_basics_complete.md](../../docs/elixir_basics_complete.md) — referência teórica
