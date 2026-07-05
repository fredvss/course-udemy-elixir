# Basics — Fundamentos antes dos cursos

Exercícios introdutórios e pequenos projetos para familiarização com o ecossistema Elixir **antes** ou **em paralelo** aos cursos em `Course-01/`, `Course-02/` e `Course-03/`.

Diferente dos módulos numerados dos cursos, aqui cada pasta é um mini-projeto autocontido focado em uma ferramenta ou conceito isolado.

## Pré-requisitos

- Elixir 1.19+ e Erlang/OTP 28 (ver [docs/asdf_installation.md](../docs/asdf_installation.md))
- `mix` disponível no PATH
- Node.js — apenas para [phoenix_hello](phoenix_hello/) (assets)

## Projetos

| Pasta | Tema | Conceitos |
|-------|------|-----------|
| [iex_basics](iex_basics/) | Scripts `.exs` para o IEx | tipos, pattern matching, pipe, `h/1` e `i/1` |
| [mix_hello](mix_hello/) | Primeiro projeto Mix com testes | `mix test`, `@doc`, ExUnit, `doctest` |
| [pattern_matching](pattern_matching/) | Exercícios de matching e guards | cláusulas, guards, tuplas `{:ok, _}` / `{:error, _}` |
| [file_io](file_io/) | Leitura e escrita de arquivos | `File.read/1`, `File.write/2`, encoding UTF-8 |
| [enum_intro](enum_intro/) | Coleções e transformações | `Enum.map/filter/reduce`, comprehensions |
| [mix_tasks](mix_tasks/) | Tarefas Mix customizadas | `Mix.Task`, `OptionParser`, automação local |
| [elixir_executable](elixir_executable/) | CLI executável com escript | `escript`, argumentos de linha de comando |
| [phoenix_hello](phoenix_hello/) | Primeiro app Phoenix | router, controllers, HEEx, API JSON |

## Ordem sugerida

```text
iex_basics → mix_hello → pattern_matching → file_io → enum_intro
     ↓
mix_tasks → elixir_executable → phoenix_hello → Course-01/01-fizz-buzz
```

Consulte [elixir_basics_complete.md](../docs/elixir_basics_complete.md) como referência teórica enquanto pratica.

## Relação com os cursos

| Onde | Foco |
|------|------|
| **Basics/** (aqui) | Ferramentas e primeiros passos — IEx, Mix, escript, Phoenix mínimo |
| **Course-01/** | Bootcamp progressivo com projetos reais (FizzBuzz → Phoenix) |
| **Course-03/01-basics/** | Exercícios de linguagem organizados por tópico (tipos, módulos, lambdas) |
| **docs/** | Handbooks de referência para consulta |

`Basics/` e `Course-03/01-basics/` são complementares: o primeiro ensina **como rodar** Elixir; o segundo aprofunda **a linguagem** em si.

> Ao adicionar um novo projeto, crie a pasta, um `README.md` próprio e atualize a tabela acima.
