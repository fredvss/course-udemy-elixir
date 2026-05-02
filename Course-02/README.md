# Course 02 — Elixir for Beginners

Three focused projects that introduce functional programming patterns in Elixir, progressing from a simple library to image generation and finally a full Phoenix web application.

## Projects

### 01-cards

A card deck manipulation library. No external dependencies. Covers pure functional transformations, list comprehensions, Erlang binary serialisation, and ExDoc documentation.

### 02-indenticon

An identicon generator that converts a text string into a deterministic 250x250 PNG image. Covers pipeline architecture with struct accumulation, MD5 hashing via `:crypto`, and image rendering via `:egd`.

### discuss

A Phoenix 1.8 discussion forum application with LiveView support, PostgreSQL persistence via Ecto, browser sessions, CSRF protection, Gettext internationalisation, and email via Swoosh.

## Progression

```
01-cards       ->  02-indenticon  ->  discuss
(pure Elixir)      (pipeline + Erlang)  (Phoenix + LiveView)
```

## Prerequisites

- Elixir >= 1.14
- Erlang/OTP >= 25
- PostgreSQL >= 14 (required by `discuss`)
