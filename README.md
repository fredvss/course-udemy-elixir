# Elixir Learning Path — Udemy Courses

This repository contains projects developed across two Udemy courses focused on the Elixir programming language and its ecosystem. The material progresses from language fundamentals through building complete web applications with the Phoenix framework.

## Repository Structure

```
course-udemy-elixir/
├── Course_01/          # Elixir + Phoenix fundamentals (Bootcamp-style)
│   ├── section01_fizz_buzz/       # Elixir core: pattern matching, I/O
│   ├── section02_ex_mon/          # OTP Agents, game state, structs
│   ├── section03_example_phoenix/ # Minimal Phoenix API with Ecto
│   └── section04_test_bank/       # Full banking API with auth and tests
└── Course_02/          # Functional patterns and Phoenix LiveView
    ├── 01-cards/        # Functional list operations and file I/O
    ├── 02-indenticon/   # Image generation pipeline
    └── discuss/         # Phoenix LiveView forum application
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

### Course 02 — Elixir for Beginners (Stephen Grider)

Introduces functional programming patterns through small focused projects, culminating in a full Phoenix LiveView application.

| Project | Concepts |
|---|---|
| Cards | Enum, pipe composition, Erlang term I/O |
| Identicon | Pipeline architecture, MD5 hashing, image rendering |
| Discuss | Phoenix, LiveView, Ecto, PostgreSQL |

## Key Technologies

- **Elixir** — functional, concurrent language built on the Erlang VM
- **Phoenix** — web framework for Elixir (v1.8.x)
- **Ecto** — database wrapper and query language
- **PostgreSQL** — relational database
- **LiveView** — server-side reactive UI
- **OTP** — Agent, Supervisor, Application behaviours

## Running a Project

Each sub-project is a standalone Mix application. To get started with any of them:

```bash
cd Course_01/section04_test_bank   # or any project directory
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
