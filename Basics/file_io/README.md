# File I/O — Leitura e escrita de arquivos

Demonstra operações básicas com o módulo `File`, tratamento de erros com tuplas `{:ok, _}` / `{:error, _}` e manipulação de strings em UTF-8.

## Conceitos

- `File.read/1` — leitura completa de um arquivo
- `File.write/2` e `File.write/3` — escrita e append
- Pattern matching no resultado das operações
- `Path.join/1` e caminhos relativos ao projeto
- `String.split/2` com `trim: true`

## Como usar

```bash
cd Basics/file_io

mix test
iex -S mix
```

No IEx:

```elixir
FileIo.Demo.read_sample()
FileIo.Demo.sample_path()
```

## Módulo

### `FileIo.Demo`

| Função | Descrição |
|--------|-----------|
| `sample_path/0` | Caminho do arquivo `data/sample.txt` |
| `read_sample/0` | Lê o arquivo de exemplo |
| `write_message/2` | Escreve texto (sobrescreve) |
| `append_line/2` | Adiciona uma linha ao final |
| `count_lines/1` | Conta linhas não vazias |

## Estrutura

```text
file_io/
├── data/sample.txt     # arquivo de exemplo
├── lib/file_io/demo.ex
├── test/
└── mix.exs
```

## Testes

```bash
mix test
```

## Próximos passos

- [Course-01/01-fizz-buzz](../../Course-01/01-fizz-buzz/) — FizzBuzz lendo números de um arquivo
- [elixir_basics_complete.md](../../docs/elixir_basics_complete.md) — seção de I/O
