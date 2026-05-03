# 04 - Processes

Processos, comunicação e tolerância a falhas em Elixir.

## Arquivos

- `spawn-process.exs` — spawn básico de processos concorrentes usando `spawn/1`
- `process-communication.exs` — envio e recebimento de mensagens entre processos com `send/2` e `receive/1`

## Subpastas

| Pasta | Conteúdo |
|-------|----------|
| `spawning-processes` | Spawn de múltiplos processos concorrentes |
| `message-passing` | Comunicação entre processos: envio simples e coleta de respostas |
| `links-and-monitors` | Tratamento de falhas com `spawn_link` e `spawn_monitor` |
| `game-of-stones-server` | Servidor de estado para o jogo Game of Stones usando processos puros |
| `game-of-stones-complete` | Versão completa do jogo com cliente e servidor |
