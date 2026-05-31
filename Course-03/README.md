# Course 03 - Elixir

Curso de Elixir cobrindo fundamentos, iteração, controle de fluxo, processos e muito mais.

## Estrutura

### 01 - Basics

Fundamentos da linguagem Elixir.

| Pasta | Conteúdo |
|-------|----------|
| `01-built-in-data-types` | Tipos de dados nativos: atoms, booleans, números, strings, listas, mapas, tuplas e keyword lists |
| `02-modules-functions` | Definição de módulos e funções nomeadas |
| `03-functions-arity-guards-clauses` | Aridade, guards e cláusulas de função |
| `04-lambda-functions` | Funções anônimas (lambdas) e closures |

### 02 - Iterations

Iteração e processamento de coleções em Elixir.

| Pasta | Conteúdo |
|-------|----------|
| `01-recursion` | Recursão básica: fatorial e map recursivo |
| `02-recursion-lists` | Recursão sobre listas: encontrando o valor máximo |
| `03-tail-call-optimization` | Otimização de chamada de cauda (TCO) com acumulador |
| `04-enum-collections` | Módulo `Enum`, `List`, `Map` e keyword lists |
| `05-streams` | Processamento lazy com o módulo `Stream` |
| `06-streams-files` | Leitura lazy de arquivos com `File.stream!` |
| `07-comprehensions` | Compreensões de lista com `for` |

### 03 - Control Flow

Controle de fluxo e tratamento de erros em Elixir.

| Pasta | Conteúdo |
|-------|----------|
| `01-conditionals` | Condicionais: `if`, `unless`, `case` e `cond` |
| `02-exceptions` | Exceções: `raise`, `try/rescue`, `throw` e `exit` |

### 04 - Processes

Processos, comunicação e tolerância a falhas em Elixir.

| Pasta | Conteúdo |
|-------|----------|
| `spawning-processes` | Spawn de múltiplos processos concorrentes |
| `message-passing` | Comunicação entre processos: envio simples e coleta de respostas |
| `links-and-monitors` | Tratamento de falhas com `spawn_link` e `spawn_monitor` |
| `game-of-stones-server` | Servidor de estado para o jogo Game of Stones usando processos puros |
| `game-of-stones-complete` | Versão completa do jogo com cliente e servidor |

### 05 - GenServer

Comportamento `GenServer` da OTP. Veja [05-genserver/README.md](05-genserver/README.md) para uma referência completa dos callbacks e exemplos de uso.

| Pasta | Conteúdo | Callbacks |
|-------|----------|-----------|
| `genserver-intro` | Primeiro GenServer, estado inicial | `init/1` |
| `genserver-init-validation` | Validação do estado inicial com guards | `init/1` |
| `genserver-calculator` | Calculadora stateful | `init/1`, `handle_call/3`, `handle_cast/2`, `terminate/2` |
| `game-of-stones` | Jogo interativo com cliente e servidor | `init/1`, `handle_call/3`, `terminate/2` |

### 06 - Mix Tool

Ferramenta `mix`: projetos, dependências, testes e escripts.

| Pasta | Conteúdo |
|-------|----------|
| `game_of_stones/` | Game of Stones como projeto Mix completo com escript e terminal colorido via `bunt` |

Conceitos abordados: `mix new`, `mix.exs`, gerenciamento de dependências (`mix deps.get`), operadores de versão SemVer, tarefas comuns, geração de escript e testes com ExUnit.

### 07 - Fault Tolerance

Tolerância a falhas com OTP: supervisores, estratégias de reinício e persistência de estado com ETS.

| Pasta | Conteúdo |
|-------|----------|
| `game_of_stones_supervised/` | Game of Stones com Supervisor: Server reinicia automaticamente ao falhar |
| `game_of_stones_ets/` | Evolução com ETS: estado do jogo sobrevive ao reinício do Server |

Conceitos abordados: `Application` behaviour, `Supervisor.start_link/2`, estratégias `:one_for_one` / `:one_for_all` / `:rest_for_one`, child spec, `start_link` vs `start`, e ETS (Erlang Term Storage).

### 08 - Distribution, Tasks and Agents

Distribuição entre nós, execução concorrente com `Task` e estado simplificado com `Agent`.

Conceitos abordados: `Task.async/await`, `Task.async_stream`, `Task.Supervisor`, `Agent.start_link/get/update`, distribuição com `Node.connect/spawn`, cookies e nomes de nó.

### 09 - Metaprogramming

Macros e metaprogramação: manipulação da AST em tempo de compilação.

Conceitos abordados: AST (`quote`/`unquote`), `defmacro`, `__using__/1`, `use`, hooks de compilação (`__before_compile__`), atributos de módulo como metadados e boas práticas.
