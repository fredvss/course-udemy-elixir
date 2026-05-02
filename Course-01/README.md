# Course 01 — Elixir and Phoenix Bootcamp

This course covers Elixir from first principles, progressing through four sections: language fundamentals, OTP state management, a basic Phoenix API, and a complete banking application with authentication and external integrations.

## Sections

### section01 — FizzBuzz

Introduction to Elixir syntax and core idioms through a classic problem. Emphasis on pattern matching with guard clauses, the pipe operator, and file I/O.

### section02 — ExMon

A turn-based battle game (Pokémon-inspired) that introduces OTP Agents for mutable game state, struct-based domain modeling, and a modular action system with randomised damage and healing.

### section03 — ExamplePhoenix

A minimal Phoenix application demonstrating the full framework setup: supervisor tree, Ecto repository, router pipelines, and a single JSON endpoint. Serves as a reference structure for Phoenix projects.

### section04 — TestBank

A production-grade banking API with user management, account operations, money transfers, Argon2 authentication, and external CEP address validation via the ViaCep API. Includes integration tests using Bypass to mock HTTP calls.

## Progression

```
FizzBuzz  ->  ExMon  ->  ExamplePhoenix  ->  TestBank
 (syntax)     (OTP)      (Phoenix basics)    (full app)
```

Each section builds on knowledge from the previous one.
