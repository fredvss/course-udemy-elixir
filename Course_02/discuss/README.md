# Discuss

A discussion forum web application built with Phoenix 1.8 and LiveView. The project demonstrates a fully scaffolded Phoenix app with browser session management, CSRF protection, Ecto/PostgreSQL persistence, LiveView for reactive UIs, and Gettext for internationalisation.

## Architecture

```
HTTP Request
    |
    v
DiscussWeb.Endpoint
    |
    v
Plug Pipeline (:browser)
  -- Plug.Session
  -- CSRF protection
  -- Flash messages
    |
    v
DiscussWeb.Router
    |
    +-- GET /  ->  PageController.home/2
```

### Supervisor Tree

```
Discuss.Application
    |
    +-- Discuss.Repo          (Ecto / PostgreSQL)
    +-- {DNSCluster, ...}
    +-- {Phoenix.PubSub, ...}
    +-- Swoosh.ApiClient       (email, dev mailbox)
    +-- DiscussWeb.Endpoint
```

## Module Overview

| Module | Responsibility |
|---|---|
| `Discuss.Application` | OTP Application, starts the supervisor tree |
| `Discuss.Repo` | Ecto repository backed by PostgreSQL |
| `DiscussWeb.Endpoint` | HTTP entry point, static file serving, session config |
| `DiscussWeb.Router` | Route and pipeline definitions |
| `DiscussWeb.Layouts` | Root and app layout templates |
| `DiscussWeb.PageController` | Renders the home page |

## Web Helpers

All LiveView and controller modules import a shared set of helpers via `DiscussWeb` macros:

- `Phoenix.Component` — function components
- `Phoenix.LiveView` — live view behaviour and helpers
- `Phoenix.HTML` — HTML tag generation
- Verified routes via the `~p` sigil
- Gettext translations

## Running

```bash
mix deps.get
mix ecto.setup
mix phx.server
```

The app is available at `http://localhost:4000`.

In development, a live email preview is available at `http://localhost:4000/dev/mailbox`.

## Running Tests

```bash
mix test
```

## Concepts Practiced

- Phoenix LiveView structure and component helpers
- Browser plug pipeline (sessions, CSRF, flash)
- Ecto repository and migration setup
- Gettext internationalisation
- Swoosh email adapter with dev mailbox
- Telemetry instrumentation
