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

Comportamento `GenServer` da OTP.

| Pasta | Conteúdo |
|-------|----------|
| `genserver-intro` | Introdução ao `GenServer` com o callback `init/1` |
| `genserver-calculator` | Calculadora stateful com `handle_call` e `handle_cast` |
| `genserver-init-validation` | Validação de estado inicial no `init/1` com guards |
| `game-of-stones` | Game of Stones implementado com `GenServer` |

### 06 - Mix Tool

Ferramenta `mix`: projetos, dependências e tarefas.

### 07 - Fault Tolerance

Supervisores e tolerância a falhas com OTP.

### 08 - Distribution, Tasks and Agents

Distribuição, `Task` e `Agent`.

### 09 - Metaprogramming

Macros e metaprogramação.
