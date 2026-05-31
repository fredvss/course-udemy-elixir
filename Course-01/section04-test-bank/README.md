# TestBank

API bancária RESTful com Phoenix 1.8, demonstrando uma aplicação próxima de produção: separação por contextos, schemas Ecto com constraints, hashing de senha com Argon2, autenticação por token, integração HTTP com ViaCep e testes de integração com Bypass.

## Arquitetura

```
Requisição HTTP
    |
    v
TestBankWeb.Endpoint
    |
    v
TestBankWeb.Router
    |
    +-- /api (público)
    |     +-- POST /users          -> UsersController.create
    |     +-- POST /users/login    -> UsersController.login
    |
    +-- /api (autenticado via plug Auth)
          +-- GET    /users/:id         -> UsersController.show
          +-- PUT    /users/:id         -> UsersController.update
          +-- DELETE /users/:id         -> UsersController.delete
          +-- POST   /accounts          -> AccountsController.create
          +-- POST   /accounts/transaction -> AccountsController.transaction
```

### Estrutura de Contextos

```
TestBank
  |
  +-- Users
  |     +-- User (schema Ecto)
  |     +-- Create       -- valida CEP via ViaCep, faz hash da senha
  |     +-- Get          -- busca por ID
  |     +-- Update       -- atualiza campos do usuário
  |     +-- Delete       -- remove o registro do usuário
  |     +-- Verify       -- login: compara senha com hash Argon2
  |
  +-- Accounts
        +-- Account (schema Ecto)
        +-- Create       -- cria conta vinculada ao usuário
        +-- Transaction  -- transfere saldo entre duas contas
```

## Schema do Banco de Dados

```
users
  id          uuid (PK)
  name        string
  email       string (único)
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
  uma conta por usuário  (unique constraint)
```

## Fluxo de Autenticação

1. `POST /api/users/login` — verifica a senha com Argon2 e retorna um token assinado.
2. Todas as rotas protegidas exigem o token no header `Authorization`.
3. O plug `TestBankWeb.Auth` decodifica o token e atribui o usuário atual ao `conn.assigns`.

## Integração Externa

Durante a criação do usuário, o `cep` (CEP brasileiro) é validado na API pública [ViaCep](https://viacep.com.br/). Se o CEP for inválido ou a requisição falhar, o usuário não é criado.

Nos testes, essa chamada HTTP é interceptada pelo [Bypass](https://github.com/PSPDFKit-Labs/bypass) para evitar requisições de rede reais.

## Principais Dependências

| Dependência | Finalidade |
|---|---|
| Phoenix 1.8.1 | Framework web |
| Ecto + Postgrex | Camada de banco de dados |
| Argon2 | Hashing de senha |
| Tesla | Cliente HTTP para ViaCep |
| Bypass | Mock de HTTP nos testes |

## Como Executar

**Com Docker:**

```bash
docker-compose up -d   # sobe o PostgreSQL
mix deps.get
mix ecto.setup
mix phx.server
```

**Sem Docker:**

Configure `config/dev.exs` com suas credenciais locais do PostgreSQL e então:

```bash
mix deps.get
mix ecto.setup
mix phx.server
```

## Testes

```bash
mix test
```

Os testes usam um banco de dados isolado e stubs Bypass para chamadas HTTP externas.

## Conceitos Praticados

- Arquitetura de contextos Phoenix (separação de domínio)
- Ecto schemas, changesets e constraints
- Hashing de senha com Argon2 via `comeonin`
- Autenticação por token como Plug
- Integração HTTP externa com Tesla
- Testes de integração com Bypass
- Configuração de banco de dados com Docker

