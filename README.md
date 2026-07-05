# Elixir — Cursos Udemy

Material prático de estudos sobre Elixir e seu ecossistema, passando pelos fundamentos da linguagem, OTP, desenvolvimento web com Phoenix e tópicos avançados como metaprogramação e distribuição.

## Pré-requisitos

| Requisito | Módulos |
|-----------|---------|
| [ASDF](docs/asdf_installation.md) + Erlang/OTP 28 + Elixir 1.19 | todos |
| PostgreSQL 14+ | Course-01/04, Course-02/03 |
| Docker + Docker Compose | Course-01/04 |

> Guia completo de instalação: [docs/asdf_installation.md](docs/asdf_installation.md)

## Estrutura do repositório

| Pasta | Tema | Documentação |
|-------|------|--------------|
| [Basics](Basics/) | Exercícios introdutórios e ferramentas antes dos cursos | [README](Basics/README.md) |
| [docs](docs/) | Handbooks de referência e guias de ambiente | [README](docs/README.md) |
| [Course-01](Course-01/) | Fundamentos de Elixir + Phoenix (bootcamp) | [README](Course-01/README.md) |
| [Course-02](Course-02/) | Padrões funcionais e Phoenix LiveView ⚠️ em andamento | [README](Course-02/README.md) |
| [Course-03](Course-03/) | OTP, processos e Elixir avançado | [README](Course-03/README.md) |

### Árvore completa

```text
course-udemy-elixir/
├── Basics/                          # Exercícios introdutórios (fora dos cursos)
│   ├── iex_basics/                  # Scripts .exs para IEx
│   ├── mix_hello/                   # Primeiro projeto Mix com testes
│   ├── pattern_matching/            # Pattern matching e guards
│   ├── file_io/                     # Leitura e escrita de arquivos
│   ├── enum_intro/                  # Enum e comprehensions
│   ├── mix_tasks/                   # Tarefas Mix customizadas
│   ├── elixir_executable/           # CLI com escript e argumentos
│   └── phoenix_hello/               # Primeiro app Phoenix (sem banco)
├── docs/                            # Handbooks e guias de referência
│   ├── asdf_installation.md
│   ├── elixir_basics_complete.md
│   ├── elixir_intermediate_complete.md
│   ├── elixir_advanced_complete.md
│   └── elixir_macros_complete.md
├── Course-01/                       # Elixir and Phoenix Bootcamp
│   ├── 01-fizz-buzz/
│   ├── 02-ex-mon/
│   ├── 03-example-phoenix/
│   └── 04-test-bank/
├── Course-02/                       # Elixir for Beginners ⚠️ em andamento
│   ├── 01-cards/
│   ├── 02-indenticon/
│   └── 03-discuss/
└── Course-03/                       # Elixir Deep Dive
    ├── 01-basics/
    ├── 02-iterations/
    ├── 03-control-flow/
    ├── 04-processes/
    ├── 05-genserver/
    ├── 06-mix-tool/
    ├── 07-fault-tolerance/
    ├── 08-distribution-tasks-agents/
    ├── 09-metaprogramming/
    └── 10-behaviour/
```

## Documentação

Fundamentos e referência em **docs/**.

### Ambiente

- [Instalação ASDF + Erlang + Elixir](docs/asdf_installation.md)

### Elixir Handbook

| Arquivo | Nível |
|---------|-------|
| [elixir_basics_complete.md](docs/elixir_basics_complete.md) | Básico |
| [elixir_intermediate_complete.md](docs/elixir_intermediate_complete.md) | Intermediário |
| [elixir_macros_complete.md](docs/elixir_macros_complete.md) | Metaprogramação |
| [elixir_advanced_complete.md](docs/elixir_advanced_complete.md) | Avançado |

> Os documentos em `docs/` complementam os exercícios práticos e podem ser lidos a qualquer momento.

## Ordem sugerida

```text
docs/asdf_installation.md
        ↓
Basics/  (iex_basics → mix_hello → … → phoenix_hello)
        ↓
Course-01  (bootcamp: sintaxe → OTP → Phoenix → app completa)
        ↓
Course-02  (projetos focados → LiveView)
        ↓
Course-03  (deep dive: processos → OTP → macros)
```

Paralelamente, consulte os handbooks em `docs/` conforme o tópico estudado.

## Cursos

### [Course 01 — Elixir and Phoenix Bootcamp](Course-01/)

Cobre o Elixir do zero, incluindo programação funcional, primitivos OTP e desenvolvimento web progressivo com Phoenix.

| Seção | Projeto | Conceitos |
|-------|---------|-----------|
| 01 | [FizzBuzz](Course-01/01-fizz-buzz/) | Pattern matching, guards, pipe operator, I/O de arquivos |
| 02 | [ExMon](Course-01/02-ex-mon/) | Agents, structs, estado de jogo, design modular |
| 03 | [ExamplePhoenix](Course-01/03-example-phoenix/) | Phoenix, Ecto, JSON API |
| 04 | [TestBank](Course-01/04-test-bank/) | CRUD, autenticação, HTTP externo, constraints com Ecto |

### [Course 02 — Elixir for Beginners](Course-02/) ⚠️ em andamento

Padrões de programação funcional por meio de projetos pequenos, culminando em uma aplicação com Phoenix LiveView.

| Seção | Projeto | Conceitos |
|-------|---------|-----------|
| 01 | [Cards](Course-02/01-cards/) | Enum, composição com pipe, I/O de termos Erlang |
| 02 | [Identicon](Course-02/02-indenticon/) | Pipeline, hash MD5, renderização de imagem |
| 03 | [Discuss](Course-02/03-discuss/) | Phoenix, LiveView, Ecto, PostgreSQL |

### [Course 03 — Elixir Deep Dive](Course-03/)

Linguagem e OTP em profundidade por meio de exercícios isolados, de tipos nativos até sistemas distribuídos e metaprogramação.

| Seção | Tópico |
|-------|--------|
| 01 | [Basics](Course-03/01-basics/) — tipos, módulos, funções, guards, lambdas |
| 02 | [Iterations](Course-03/02-iterations/) — recursão, Enum, Stream, comprehensions |
| 03 | [Control Flow](Course-03/03-control-flow/) — condicionais e exceções |
| 04 | [Processes](Course-03/04-processes/) — spawn, mensagens, links, monitors |
| 05 | [GenServer](Course-03/05-genserver/) — behaviour GenServer e padrões OTP |
| 06 | [Mix Tool](Course-03/06-mix-tool/) — projetos Mix, deps, escript, tarefas |
| 07 | [Fault Tolerance](Course-03/07-fault-tolerance/) — supervisors e tolerância a falhas |
| 08 | [Distribution](Course-03/08-distribution-tasks-agents/) — nós distribuídos, Task, Agent |
| 09 | [Metaprogramming](Course-03/09-metaprogramming/) — macros, quote/unquote |
| 10 | [Behaviour](Course-03/10-behaviour/) — `@behaviour`, `@callback`, polimorfismo |

## Conceitos estudados

- Pattern matching e guards
- Pipe operator e composição funcional
- Módulos, funções, aridade e lambdas
- Recursão, Enum, Stream e comprehensions
- Processos, mensagens, links e monitors
- GenServer, Agent, Supervisor e Application
- Task, distribuição entre nós e ETS
- Mix, escript, dependências e testes com ExUnit
- Phoenix, Ecto, LiveView e PostgreSQL
- Metaprogramação: `quote`/`unquote`, macros, protocols e behaviours

## Tecnologias principais

- **Elixir** — linguagem funcional e concorrente sobre a VM Erlang
- **Phoenix** — framework web para Elixir (v1.8.x)
- **Ecto** — wrapper de banco de dados e linguagem de queries
- **PostgreSQL** — banco de dados relacional
- **LiveView** — UI reativa server-side
- **OTP** — behaviours GenServer, Agent, Supervisor, Application

## Licença

Material de estudo pessoal — use livremente para aprendizado.
