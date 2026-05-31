# Discuss

Fórum de discussões web desenvolvido com Phoenix 1.8 e LiveView. O projeto demonstra uma aplicação Phoenix completa com gerenciamento de sessão, proteção CSRF, persistência via Ecto/PostgreSQL, LiveView para UIs reativas e internacionalização com Gettext.

## Arquitetura

```
Requisição HTTP
    |
    v
DiscussWeb.Endpoint
    |
    v
Pipeline de Plugs (:browser)
  -- Plug.Session
  -- Proteção CSRF
  -- Mensagens Flash
    |
    v
DiscussWeb.Router
    |
    +-- GET /  ->  PageController.home/2
```

### Árvore de Supervisão

```
Discuss.Application
    |
    +-- Discuss.Repo          (Ecto / PostgreSQL)
    +-- {DNSCluster, ...}
    +-- {Phoenix.PubSub, ...}
    +-- Swoosh.ApiClient       (email, caixa de entrada dev)
    +-- DiscussWeb.Endpoint
```

## Módulos

| Módulo | Responsabilidade |
|---|---|
| `Discuss.Application` | OTP Application, inicia a árvore de supervisão |
| `Discuss.Repo` | Repositório Ecto com PostgreSQL |
| `DiscussWeb.Endpoint` | Ponto de entrada HTTP, arquivos estáticos, config de sessão |
| `DiscussWeb.Router` | Definições de rotas e pipelines |
| `DiscussWeb.Layouts` | Templates de layout raiz e app |
| `DiscussWeb.PageController` | Renderiza a página inicial |

## Helpers Web

Todos os módulos LiveView e controller importam um conjunto compartilhado de helpers via macros `DiscussWeb`:

- `Phoenix.Component` — function components
- `Phoenix.LiveView` — behaviour e helpers de live view
- `Phoenix.HTML` — geração de tags HTML
- Rotas verificadas via sigil `~p`
- Traduções via Gettext

## Como Executar

```bash
mix deps.get
mix ecto.setup
mix phx.server
```

A aplicação fica disponível em `http://localhost:4000`.

Em desenvolvimento, uma prévia de emails está disponível em `http://localhost:4000/dev/mailbox`.

## Testes

```bash
mix test
```

## Conceitos Praticados

- Estrutura e componentes do Phoenix LiveView
- Pipeline browser (sessões, CSRF, flash)
- Configuração do repositório Ecto e migrations
- Internacionalização com Gettext
- Adaptador de email Swoosh com caixa de entrada de desenvolvimento
- Instrumentação com Telemetria
