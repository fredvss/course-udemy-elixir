# Game of Stones — GenServer

Jogo de pedras para dois jogadores implementado com `GenServer`. Os jogadores se alternam pegando de 1 a 3 pedras por vez. **Quem pegar a última pedra perde** — o outro jogador vence.

`GameOfStones.Server` mantém o estado da partida (jogador atual e contagem de pedras) e responde a `call`s síncronos para consultar o estado e realizar jogadas. `GameOfStones.Client` é um cliente interativo com loop de jogo e validação de entrada.

## Arquivos

- `game_of_stones.exs` — `GameOfStones.Server` (GenServer) e `GameOfStones.Client` (loop interativo) em um único script.

> A versão como projeto Mix com escript e terminal colorido está em `Course-03/06-mix-tool/game_of_stones/`.

## Como rodar

### Via terminal (sem REPL)

```bash
elixir game_of_stones.exs
```

Passando um número customizado de pedras (padrão: 30):

```bash
elixir -e "GameOfStones.Client.play(10)" game_of_stones.exs
```

### Via IEx

```bash
iex game_of_stones.exs
```

```elixir
iex> GameOfStones.Client.play()
iex> GameOfStones.Client.play(10)  # partida com 10 pedras
```

## API do servidor

```elixir
GameOfStones.Server.start(n)   # inicia o servidor com n pedras (padrão: 30)
GameOfStones.Server.stats()    # retorna {jogador_atual, pedras_restantes}
GameOfStones.Server.take(n)    # pega n pedras (1–3)
```

### Retornos de `take/1`

| Resultado | Significado |
|---|---|
| `{:next_turn, jogador, pedras}` | Vez do `jogador` com `pedras` restantes |
| `{:winner, jogador}` | `jogador` venceu (o adversário pegou a última pedra) |
| `{:error, mensagem}` | Jogada inválida: fora do intervalo 1–3 ou mais do que o disponível |

## Comportamentos importantes

- **O processo encerra ao fim da partida** — após retornar `{:winner, ...}`, o GenServer para (`:stop, :normal`). Qualquer chamada posterior causa crash. Para uma nova partida, chame `start/1` novamente.
- **`take/1` não valida o turno** — o servidor aceita jogadas de qualquer chamador; a alternância de turno é controlada pelo estado interno, não por quem faz a chamada.

## Exemplo de partida completa

```elixir
GameOfStones.Server.start(5)
# => {:ok, #PID<...>}

GameOfStones.Server.stats()
# => {1, 5}

GameOfStones.Server.take(3)   # jogador 1 pega 3
# => {:next_turn, 2, 2}

GameOfStones.Server.take(1)   # jogador 2 pega 1
# => {:next_turn, 1, 1}

GameOfStones.Server.take(1)   # jogador 1 pega a última → perde
# => {:winner, 2}
```
