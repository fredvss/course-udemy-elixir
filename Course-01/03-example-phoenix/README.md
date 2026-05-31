# ExamplePhoenix

Aplicação Phoenix 1.8 mínima demonstrando a estrutura padrão do projeto, árvore de supervisão OTP, configuração do repositório Ecto e um endpoint JSON. Serve como referência antes de construir uma aplicação completa.

## Arquitetura

```
Requisição HTTP
    |
    v
ExamplePhoenixWeb.Endpoint
    |
    v
Pipeline de Plugs (escopo :api)
    |
    v
ExamplePhoenixWeb.Router
    |
    +-- GET /api/welcome  ->  WelcomeController.index/2
                                    |
                                    v
                              JSON: {"message": "Welcome"}
```

### Árvore de Supervisão

```
ExamplePhoenix.Application
    |
    +-- ExamplePhoenix.Repo      (Ecto / PostgreSQL)
    +-- {DNSCluster, ...}
    +-- {Phoenix.PubSub, ...}
    +-- ExamplePhoenixWeb.Endpoint
```

## Módulos

| Módulo | Responsabilidade |
|---|---|
| `ExamplePhoenix.Application` | OTP Application, inicia a árvore de supervisão |
| `ExamplePhoenix.Repo` | Repositório Ecto com PostgreSQL |
| `ExamplePhoenixWeb.Endpoint` | Ponto de entrada HTTP, pipeline de plugs |
| `ExamplePhoenixWeb.Router` | Definições de rotas e pipelines |
| `ExamplePhoenixWeb.WelcomeController` | Retorna uma mensagem JSON estática de boas-vindas |

## Endpoints

| Método | Caminho | Resposta |
|---|---|---|
| GET | `/api/welcome` | `{"message": "Welcome"}` |

## Como Executar

```bash
mix deps.get
mix ecto.setup
mix phx.server
```

O servidor sobe em `http://localhost:4000`.

## Conceitos Praticados

- Estrutura de projeto Phoenix e convenções
- OTP Application e Supervisor
- Configuração do repositório Ecto
- Pipelines do router (`:api`)
- Respostas JSON com `Phoenix.Controller.json/2`
- Cadeia de middlewares Plug
