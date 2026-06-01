# Elixir Learning Path — Cursos Udemy

Repositório com projetos e exercícios desenvolvidos ao longo de três cursos Udemy focados em Elixir e seu ecossistema. O conteúdo evolui dos fundamentos da linguagem até OTP, desenvolvimento web com Phoenix e tópicos avançados como metaprogramação e distribuição.

## Estrutura

```
course-udemy-elixir/
├── Course-01/          # Fundamentos de Elixir + Phoenix (estilo bootcamp)
│   ├── 01-fizz-buzz/              # Core do Elixir: pattern matching, I/O
│   ├── 02-ex-mon/                 # OTP Agents, estado de jogo, structs
│   ├── 03-example-phoenix/        # API mínima com Phoenix e Ecto
│   └── 04-test-bank/              # API bancária completa com auth e testes
├── Course-02/          # Padrões funcionais e Phoenix LiveView  ⚠️ em andamento
│   ├── 01-cards/        # Operações funcionais em listas e I/O de arquivos
│   ├── 02-indenticon/   # Pipeline de geração de imagens
│   └── 03-discuss/      # Fórum com Phoenix LiveView
└── Course-03/          # Aprofundamento: OTP, processos e Elixir avançado
    ├── 01-basics/               # Tipos, módulos, funções, lambdas
    ├── 02-iterations/           # Recursão, Enum, Stream, comprehensions
    ├── 03-control-flow/         # Condicionais e exceções
    ├── 04-processes/            # Spawn, troca de mensagens, links e monitors
    ├── 05-genserver/            # Behaviour GenServer e padrões OTP
    ├── 06-mix-tool/             # Projetos Mix, deps, escript e tarefas
    ├── 07-fault-tolerance/      # Supervisors e tolerância a falhas
    ├── 08-distribution-tasks-agents/ # Nós distribuídos, Task e Agent
    ├── 09-metaprogramming/      # Macros, quote/unquote, geração de código
    └── 10-behaviour/            # @behaviour, @callback, polimorfismo via módulo
```

## Cursos

### [Course 01 — Elixir and Phoenix Bootcamp](Course-01/)

Cobre o Elixir do zero, incluindo programação funcional, primitivos OTP e desenvolvimento web progressivo com Phoenix.

| Seção | Projeto | Conceitos |
|---|---|---|
| 01 | FizzBuzz | Pattern matching, guards, pipe operator, I/O de arquivos |
| 02 | ExMon | Agents, structs, estado de jogo, design modular |
| 03 | ExamplePhoenix | Phoenix, Ecto, JSON API |
| 04 | TestBank | CRUD, autenticação, HTTP externo, constraints com Ecto |

### [Course 02 — Elixir for Beginners](Course-02/) ⚠️ em andamento

Apresenta padrões de programação funcional por meio de projetos pequenos e focados, culminando em uma aplicação completa com Phoenix LiveView.

| Seção | Projeto | Conceitos |
|---|---|---|
| 01 | Cards | Enum, composição com pipe, I/O de termos Erlang |
| 02 | Identicon | Arquitetura de pipeline, hash MD5, renderização de imagem |
| 03 | Discuss | Phoenix, LiveView, Ecto, PostgreSQL |

### [Course 03 — Elixir Deep Dive](Course-03/)

Cobre a linguagem e OTP em profundidade por meio de exercícios isolados, progredindo de tipos nativos até sistemas distribuídos e metaprogramação.

| Seção | Conceitos |
|---|---|
| 01 — Basics | Tipos nativos, módulos, funções, aridade, guards, lambdas |
| 02 — Iterations | Recursão, tail-call optimisation, Enum, Stream, comprehensions |
| 03 — Control Flow | `if`/`unless`/`case`/`cond`, exceções com `try/rescue` |
| 04 — Processes | Spawn, troca de mensagens, links, monitors, process server stateful |
| 05 — GenServer | `init`, `handle_call`, `handle_cast`, validação no init |
| 06 — Mix Tool | Projetos Mix, dependências externas, escript, tarefas customizadas |
| 07 — Fault Tolerance | Supervisors, árvores de supervisão |
| 08 — Distribution, Tasks e Agents | Nós distribuídos, `Task`, `Agent` |
| 09 — Metaprogramming | `quote`/`unquote`, `defmacro`, `require`/`import`/`use`, `defprotocol`, `defimpl` |
| 10 — Behaviour | `@behaviour`, `@callback`, `@optional_callbacks`, `@impl`, polimorfismo via módulo |

## Tecnologias principais

- **Elixir** — linguagem funcional e concorrente sobre a VM Erlang
- **Phoenix** — framework web para Elixir (v1.8.x)
- **Ecto** — wrapper de banco de dados e linguagem de queries
- **PostgreSQL** — banco de dados relacional
- **LiveView** — UI reativa server-side
- **OTP** — behaviours GenServer, Agent, Supervisor, Application
