# Course 02 — Elixir for Beginners ⚠️ em andamento

Três projetos focados que introduzem padrões de programação funcional em Elixir, progredindo de uma biblioteca simples até geração de imagens e uma aplicação web completa com Phoenix LiveView.

## Projetos

### [01 — Cards](01-cards/README.md)

Biblioteca de manipulação de baralho sem dependências externas. Cobre transformações funcionais puras, compreensões de lista, serialização binária Erlang e documentação com ExDoc.

Conceitos abordados: compreensões de lista (`for`), pipe operator `|>`, pattern matching em resultados de arquivo, serialização com `:erlang.term_to_binary`, `ExDoc` com `@doc`.

### [02 — Identicon](02-indenticon/README.md)

Gerador de identicons que converte texto em uma imagem PNG 250×250 determinística. Cobre arquitetura de pipeline com struct acumulador, hash MD5 via `:crypto` e renderização de imagem via `:egd`.

Conceitos abordados: arquitetura de pipeline com `|>` e struct acumulador, interop com Erlang (`:crypto`, `:egd`), `Enum.chunk_every/2`, funções de hash determinísticas.

### [03 — Discuss](03-discuss/README.md)

Fórum de discussões web com Phoenix 1.8 e LiveView. Demonstra uma aplicação Phoenix completa com gerenciamento de sessão, proteção CSRF, persistência via Ecto/PostgreSQL, LiveView para UIs reativas e internacionalização com Gettext.

Conceitos abordados: Phoenix LiveView, pipeline browser (sessões, CSRF, flash), Ecto repository e migrations, Gettext, adaptador de email Swoosh, telemetria.

## Progressão

```
01-cards         ->  02-indenticon       ->  03-discuss
(Elixir puro)        (pipeline + Erlang)     (Phoenix + LiveView)
```

## Pré-requisitos

- Elixir >= 1.14
- Erlang/OTP >= 25
- PostgreSQL >= 14 (necessário pelo `03-discuss`)
