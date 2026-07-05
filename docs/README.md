# Docs — Study Elixir

Documentação de referência e handbooks para o ambiente de estudos Elixir/Phoenix.

Índice geral do repositório: [README.md](../README.md) · Exercícios introdutórios: [Basics/README.md](../Basics/README.md)

---

## Conteúdo

### Ambiente

| Arquivo | Descrição |
|---|---|
| [asdf_installation.md](asdf_installation.md) | Instalação do ASDF 0.18 (binário) + Erlang/OTP 28 + Elixir 1.19 no Linux Mint/Ubuntu. Inclui configuração de ambiente, plugins, comandos de gerenciamento de versões e troubleshooting. |

---

### Elixir Handbook

Série de guias de referência organizados por nível. Cada arquivo é autocontido e pode ser consultado independentemente.

| Arquivo | Nível | Tópicos |
|---|---|---|
| [elixir_basics_complete.md](elixir_basics_complete.md) | Básico | Tipos, operadores, pattern matching, control flow, funções, módulos, List/Tuple/Map/MapSet, Enum, Stream, recursão, pipe, comprehensions, sigils, structs, error handling |
| [elixir_intermediate_complete.md](elixir_intermediate_complete.md) | Intermediário | Processos, links/monitors, mensagens, Task, Agent, GenServer, Supervisor, DynamicSupervisor, Application, ETS, Protocols, Behaviours, typespecs, Mix |
| [elixir_advanced_complete.md](elixir_advanced_complete.md) | Avançado | BEAM internals, GC por processo, OTP design, distribuição, hot code reload, NIFs/Ports, performance, Telemetry, Mix releases, observabilidade, GenStage/Broadway |
| [elixir_macros_complete.md](elixir_macros_complete.md) | Metaprogramação | AST, quote/unquote, import, require, use, defmacro, higiene, atributos, hooks de compilação, DSL, quando usar macros |

---

## Trilha sugerida

```
1. asdf_installation.md      → configurar o ambiente
2. elixir_basics_complete.md → fundamentos da linguagem
3. elixir_intermediate_complete.md → OTP e concorrência
4. elixir_macros_complete.md → metaprogramação
5. elixir_advanced_complete.md → BEAM internals e produção
```
