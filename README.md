# Elixir Learning Path — Udemy Courses

This repository contains projects and exercises developed across three Udemy courses focused on the Elixir programming language and its ecosystem. The material progresses from language fundamentals through OTP, Phoenix web development, and advanced topics such as metaprogramming and distribution.

## Repository Structure

```
course-udemy-elixir/
├── Course-01/          # Elixir + Phoenix fundamentals (Bootcamp-style)
│   ├── section01-fizz-buzz/       # Elixir core: pattern matching, I/O
│   ├── section02-ex-mon/          # OTP Agents, game state, structs
│   ├── section03-example-phoenix/ # Minimal Phoenix API with Ecto
│   └── section04-test-bank/       # Full banking API with auth and tests
├── Course-02/          # Functional patterns and Phoenix LiveView
│   ├── 01-cards/        # Functional list operations and file I/O
│   ├── 02-indenticon/   # Image generation pipeline
│   └── 03-discuss/      # Phoenix LiveView forum application
└── Course-03/          # Deep dive: OTP, processes, and advanced Elixir
    ├── 01-basics/               # Built-in types, modules, functions, lambdas
    ├── 02-iterations/           # Recursion, Enum, Stream, comprehensions
    ├── 03-control-flow/         # Conditionals and exceptions
    ├── 04-processes/            # Spawn, message passing, links and monitors
    ├── 05-genserver/            # GenServer behaviour and OTP patterns
    ├── 06-mix-tool/             # Mix projects, deps and tasks
    ├── 07-fault-tolerance/      # Supervisors and fault tolerance
    ├── 08-distribution-tasks-agents/ # Distribution, Task and Agent
    └── 09-metaprogramming/      # Macros and metaprogramming
```

## Courses

### Course 01 — Elixir and Phoenix Bootcamp

Covers the Elixir language from scratch, including functional programming concepts, OTP primitives, and progressive Phoenix web development.

| Section | Project | Concepts |
|---|---|---|
| 01 | FizzBuzz | Pattern matching, guards, pipe operator, file I/O |
| 02 | ExMon | Agents, structs, game state, modular design |
| 03 | ExamplePhoenix | Phoenix framework, Ecto, JSON API |
| 04 | TestBank | CRUD, authentication, external HTTP, Ecto constraints |

### Course 02 — Elixir for Beginners

Introduces functional programming patterns through small focused projects, culminating in a full Phoenix LiveView application.

| Project | Concepts |
|---|---|
| Cards | Enum, pipe composition, Erlang term I/O |
| Identicon | Pipeline architecture, MD5 hashing, image rendering |
| Discuss | Phoenix, LiveView, Ecto, PostgreSQL |

### Course 03 — Elixir Deep Dive

Covers the language and OTP in depth through isolated exercises, progressing from built-in types to distributed systems and metaprogramming.

| Section | Concepts |
|---|---|
| 01 — Basics | Built-in data types, modules, functions, arity, guards, lambdas |
| 02 — Iterations | Recursion, tail-call optimisation, Enum, Stream, comprehensions |
| 03 — Control Flow | `if`/`unless`/`case`/`cond`, exceptions with `try/rescue` |
| 04 — Processes | Spawn, message passing, links, monitors, stateful process server |
| 05 — GenServer | `init`, `handle_call`, `handle_cast`, init validation |
| 06 — Mix Tool | Mix projects, dependencies, custom tasks |
| 07 — Fault Tolerance | Supervisors, supervision trees |
| 08 — Distribution, Tasks and Agents | Distributed nodes, `Task`, `Agent` |
| 09 — Metaprogramming | Macros, `quote`/`unquote`, compile-time code generation |

## Key Technologies

- **Elixir** — functional, concurrent language built on the Erlang VM
- **Phoenix** — web framework for Elixir (v1.8.x)
- **Ecto** — database wrapper and query language
- **PostgreSQL** — relational database
- **LiveView** — server-side reactive UI
- **OTP** — GenServer, Agent, Supervisor, Application behaviours

## Running a Project

Each sub-project is a standalone Mix application. To get started with any of them:

```bash
cd Course-01/section04-test-bank   # or any project directory
mix deps.get
mix ecto.setup                     # only for database projects
mix phx.server                     # only for Phoenix projects
```

For non-web projects:

```bash
iex -S mix
```

## Prerequisites

- Elixir >= 1.14
- Erlang/OTP >= 25
- PostgreSQL >= 14 (required by sections 03, 04 and discuss)
- Docker (optional, for section04 via `docker-compose up`)
