# Phoenix Hello — Primeiro app web

App Phoenix mínimo gerado com `mix phx.new`, **sem banco de dados** (`--no-ecto`). Introduz rotas, controllers, páginas HTML com HEEx e uma API JSON simples.

## Conceitos

- Estrutura de um projeto Phoenix (`lib/`, `assets/`, `config/`)
- Router com pipelines `:browser` e `:api`
- Controller HTML (`PageController`) e JSON (`HelloController`)
- Templates HEEx e layout
- `mix phx.server` e hot-reload em desenvolvimento
- Testes com `Phoenix.ConnTest`

## Pré-requisitos

- Elixir 1.19+ e Erlang/OTP 28
- Node.js (para compilar assets com esbuild/tailwind na primeira execução)

## Como usar

```bash
cd Basics/phoenix_hello

mix setup
mix phx.server
```

Abra no navegador:

- [http://localhost:4000](http://localhost:4000) — página inicial (HTML)
- [http://localhost:4000/api/hello](http://localhost:4000/api/hello) — JSON de boas-vindas
- [http://localhost:4000/api/hello/Elixir](http://localhost:4000/api/hello/Elixir) — JSON personalizado

## Rotas

| Método | Caminho | Controller | Resposta |
|--------|---------|------------|----------|
| GET | `/` | `PageController.home/2` | Página HTML |
| GET | `/api/hello` | `HelloController.show/2` | `{"message": "Olá do Phoenix!", ...}` |
| GET | `/api/hello/:name` | `HelloController.show/2` | `{"message": "Olá, Nome!", ...}` |

## Estrutura principal

```text
phoenix_hello/
├── lib/phoenix_hello_web/
│   ├── router.ex              # rotas e pipelines
│   ├── controllers/
│   │   ├── page_controller.ex # página HTML
│   │   └── hello_controller.ex# API JSON
│   └── controllers/page_html/ # templates HEEx
├── assets/                    # CSS/JS (tailwind + esbuild)
├── config/                    # configuração por ambiente
└── test/                      # testes de controller
```

## Testes

```bash
mix test
```

## Comandos úteis

```bash
mix phx.server          # servidor de desenvolvimento
iex -S mix phx.server   # servidor dentro do IEx
mix precommit           # compile + format + test
```

## Diferença para Course-01/03-example-phoenix

Este projeto é **intencionalmente mínimo** — sem Ecto, PostgreSQL ou LiveDashboard. O [ExamplePhoenix](../../Course-01/03-example-phoenix/) adiciona banco de dados e API com persistência.

## Próximos passos

- [Course-01/03-example-phoenix](../../Course-01/03-example-phoenix/) — Phoenix com Ecto e PostgreSQL
- [Course-02/03-discuss](../../Course-02/03-discuss/) — Phoenix com LiveView

## Referências

- [Phoenix Guides](https://phoenix.hexdocs.pm/overview.html)
- [Phoenix.Router](https://hexdocs.pm/phoenix/Phoenix.Router.html)
