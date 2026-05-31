# Course 01 — Elixir and Phoenix Bootcamp

Curso que cobre o Elixir do zero, progredindo por quatro seções: fundamentos da linguagem, gerenciamento de estado com OTP, uma API Phoenix básica e uma aplicação bancária completa com autenticação e integrações externas.

## Seções

### [01 — FizzBuzz](01-fizz-buzz/)

Introdução à sintaxe e idiomas centrais do Elixir por meio do problema clássico FizzBuzz. Ênfase em pattern matching com guards, pipe operator e I/O de arquivos.

Conceitos abordados: pattern matching, guard clauses, pipe operator `|>`, tuplas `{:ok, value}` / `{:error, reason}`, `File.read/1`, `Enum.map/2`.

### [02 — ExMon](02-ex-mon/)

Jogo de batalha por turnos inspirado em Pokémon, que demonstra OTP Agents para estado mutável, modelagem de domínio com structs e despacho de ações modular com dano e cura aleatórios.

Conceitos abordados: `Agent`, structs, pattern matching para fluxo de controle, `Enum.random/1`, design modular com módulos de ação separados.

### [03 — ExamplePhoenix](03-example-phoenix/)

Aplicação Phoenix 1.8 mínima demonstrando a estrutura padrão do framework: árvore de supervisão OTP, repositório Ecto e um endpoint JSON. Serve como referência antes de construir uma aplicação completa.

Conceitos abordados: estrutura de projeto Phoenix, `Application` e `Supervisor`, Ecto repository, pipelines do Router (`:api`), respostas JSON com `Phoenix.Controller.json/2`.

### [04 — TestBank](04-test-bank/)

API bancária RESTful com Phoenix 1.8 demonstrando uma aplicação próxima de produção: separação por contextos, schemas Ecto com constraints, hashing de senha com Argon2, autenticação por token, integração com a API ViaCep e testes de integração com Bypass.

Conceitos abordados: arquitetura de contextos Phoenix, Ecto changesets e constraints, Argon2, autenticação como Plug, cliente HTTP com Tesla, testes com Bypass, Docker com `docker-compose`.

## Progressão

```
FizzBuzz  ->  ExMon  ->  ExamplePhoenix  ->  TestBank
(sintaxe)     (OTP)      (Phoenix básico)    (app completa)
```

Cada seção constrói sobre o conhecimento da anterior.
