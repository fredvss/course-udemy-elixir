# ExamplePhoenix

A minimal Phoenix 1.8 application demonstrating the standard project structure, OTP supervision tree, Ecto repository setup, and a single JSON API endpoint. It serves as a reference baseline before building a full application.

## Architecture

```
HTTP Request
    |
    v
ExamplePhoenixWeb.Endpoint
    |
    v
Plug Pipeline (:api scope)
    |
    v
ExamplePhoenixWeb.Router
    |
    +-- GET /api/welcome  ->  WelcomeController.index/2
                                    |
                                    v
                              JSON: {"message": "Welcome"}
```

### Supervisor Tree

```
ExamplePhoenix.Application
    |
    +-- ExamplePhoenix.Repo      (Ecto / PostgreSQL)
    +-- {DNSCluster, ...}
    +-- {Phoenix.PubSub, ...}
    +-- ExamplePhoenixWeb.Endpoint
```

## Module Overview

| Module | Responsibility |
|---|---|
| `ExamplePhoenix.Application` | OTP Application, starts the supervisor tree |
| `ExamplePhoenix.Repo` | Ecto repository backed by PostgreSQL |
| `ExamplePhoenixWeb.Endpoint` | HTTP entry point, plug pipeline |
| `ExamplePhoenixWeb.Router` | Route definitions and pipeline declarations |
| `ExamplePhoenixWeb.WelcomeController` | Returns a static JSON welcome message |

## Endpoints

| Method | Path | Response |
|---|---|---|
| GET | `/api/welcome` | `{"message": "Welcome"}` |

## Running

```bash
mix deps.get
mix ecto.setup
mix phx.server
```

The server starts at `http://localhost:4000`.

## Concepts Practiced

- Phoenix project structure and conventions
- OTP Application and Supervisor
- Ecto repository configuration
- Router pipelines (`:api`)
- JSON responses with `Phoenix.Controller.json/2`
- Plug middleware chain
