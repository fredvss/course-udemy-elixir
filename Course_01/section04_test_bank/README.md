# TestBank

A RESTful banking API built with Phoenix 1.8, demonstrating a full production-like application: context-based domain separation, Ecto schemas with constraints, Argon2 password hashing, token authentication, external HTTP integration with ViaCep, and integration tests using Bypass.

## Architecture

```
HTTP Request
    |
    v
TestBankWeb.Endpoint
    |
    v
TestBankWeb.Router
    |
    +-- /api (public)
    |     +-- POST /users          -> UsersController.create
    |     +-- POST /users/login    -> UsersController.login
    |
    +-- /api (authenticated via Auth plug)
          +-- GET    /users/:id         -> UsersController.show
          +-- PUT    /users/:id         -> UsersController.update
          +-- DELETE /users/:id         -> UsersController.delete
          +-- POST   /accounts          -> AccountsController.create
          +-- POST   /accounts/transaction -> AccountsController.transaction
```

### Context Structure

```
TestBank
  |
  +-- Users
  |     +-- User (Ecto schema)
  |     +-- Create       -- validates CEP via ViaCep, hashes password
  |     +-- Get          -- fetch by ID
  |     +-- Update       -- update user fields
  |     +-- Delete       -- delete user record
  |     +-- Verify       -- login: compares password with Argon2 hash
  |
  +-- Accounts
        +-- Account (Ecto schema)
        +-- Create       -- creates account linked to user
        +-- Transaction  -- transfers balance between two accounts
```

## Database Schema

```
users
  id          uuid (PK)
  name        string
  email       string (unique)
  cep         string
  password_hash string
  inserted_at / updated_at

accounts
  id          uuid (PK)
  user_id     uuid (FK -> users)
  balance     decimal
  inserted_at / updated_at

Constraints:
  accounts.balance >= 0  (check constraint)
  one account per user   (unique constraint)
```

## Authentication Flow

1. `POST /api/users/login` — verifies password with Argon2, returns a signed token.
2. All protected routes require the token in the `Authorization` header.
3. `TestBankWeb.Auth` plug decodes the token and assigns the current user to `conn.assigns`.

## External Integration

During user creation, the provided `cep` (Brazilian postal code) is validated against the [ViaCep](https://viacep.com.br/) public API. If the CEP is invalid or the request fails, the user is not created.

In tests, this HTTP call is intercepted by [Bypass](https://github.com/PSPDFKit-Labs/bypass) to avoid real network requests.

## Key Dependencies

| Dependency | Purpose |
|---|---|
| Phoenix 1.8.1 | Web framework |
| Ecto + Postgrex | Database layer |
| Argon2 | Password hashing |
| Tesla | HTTP client for ViaCep |
| Bypass | Mocking HTTP in tests |

## Running

**With Docker:**

```bash
docker-compose up -d   # starts PostgreSQL
mix deps.get
mix ecto.setup
mix phx.server
```

**Without Docker:**

Configure `config/dev.exs` with your local PostgreSQL credentials, then:

```bash
mix deps.get
mix ecto.setup
mix phx.server
```

## Running Tests

```bash
mix test
```

Tests use an isolated database and Bypass stubs for external HTTP calls.

## Concepts Practiced

- Phoenix context architecture (domain separation)
- Ecto schemas, changesets, and constraints
- Argon2 password hashing with `comeonin`
- Token-based authentication as a Plug
- External HTTP integration with Tesla
- Integration tests with Bypass
- Docker-based database setup
