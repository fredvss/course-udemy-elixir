# FizzBuzz

Implementação do clássico problema FizzBuzz em Elixir, usada como introdução prática aos recursos centrais da linguagem: pattern matching, guard clauses, pipe operator e I/O de arquivos.

O programa lê um arquivo contendo uma lista de inteiros separados por vírgula e transforma cada valor de acordo com as regras do FizzBuzz, retornando uma lista de átomos ou números.

## Arquitetura

```
numbers.txt
    |
    v
FizzBuzz.build/1
    |
    +-- File.read/1
    |       |
    |   handle_file_read/1  -- tupla de erro -> imprime o erro
    |       |
    |   convert_and_evaluate_numbers/1
    |       |
    |   String.split -> Enum.map -> evaluate_numbers/1
    |                                   |
    |                               pattern match com guards
    |                               :fizz | :buzz | :fizzbuzz | n
    |
    v
  [lista de resultados]
```

## Módulo

### `FizzBuzz`

| Função | Descrição |
|---|---|
| `build/1` | Ponto de entrada. Lê um arquivo e retorna a lista avaliada. |
| `handle_file_read/1` | Pattern match em `{:ok, body}` ou `{:error, reason}`. |
| `convert_and_evaluate_numbers/1` | Divide a string do arquivo, converte para inteiros e aplica `evaluate_numbers/1`. |
| `evaluate_numbers/1` | Retorna `:fizzbuzz`, `:fizz`, `:buzz` ou o próprio número usando guards. |

## Conceitos Praticados

- Pattern matching com guard clauses (`rem(n, 3) == 0`)
- Pipe operator `|>` para compor transformações
- Tratamento de erros com tuplas `{:ok, value}` / `{:error, reason}`
- Leitura de arquivo com `File.read/1`
- `Enum.map/2` e `String.split/2`

## Como Executar

```bash
mix test
```

Ou no IEx:

```elixir
iex -S mix
FizzBuzz.build("numbers.txt")
# => [1, 2, :fizz, 4, :buzz, :fizz, 7, 8, :fizz, :buzz, ...]
```

## Formato do Arquivo de Entrada

O arquivo `numbers.txt` deve conter uma única linha de inteiros separados por vírgula:

```
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
```

