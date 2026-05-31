# ExMon

Jogo de batalha por turnos inspirado em Pokémon, desenvolvido para demonstrar OTP Agents, modelagem de domínio com structs e despacho de ações modular em Elixir.

Dois jogadores lutam entre si escolhendo movimentos a cada turno. Cada jogador começa com 100 HP, possui três movimentos (dois de ataque e um de cura) e perde quando seu HP chega a 0. Após o jogador agir, o computador faz sua própria jogada com um movimento escolhido aleatoriamente.

## Arquitetura

```
ExMon (API pública)
  |
  +-- create_player/4       -> %Player{}
  +-- start_game/1          -> ExMon.Game (Agent)
  +-- make_move/1
        |
        +-- ExMon.Game.Actions.fetch_move/2
              |
              +-- :move_rnd / :move_avg  -> Attack.attack_opponent/2
              +-- :move_heal             -> Heal.heal_life/1
              |
              v
        ExMon.Game.update/1  (atualiza estado do Agent)
              |
        ExMon.Game.Status.print_round_result/1
              |
        verifica fim de jogo / turno do computador
```

## Módulos

| Módulo | Responsabilidade |
|---|---|
| `ExMon` | API pública: criação do jogador, início do jogo, despacho de movimentos |
| `ExMon.Player` | Struct: `name`, `life` (100), mapa de `moves` |
| `ExMon.Game` | OTP Agent com o estado atual do jogo |
| `ExMon.Game.Actions` | Despacha movimentos para Attack ou Heal |
| `ExMon.Game.Actions.Attack` | Calcula e aplica dano (18–35 HP, intervalo aleatório) |
| `ExMon.Game.Actions.Heal` | Restaura HP (18–25 HP, máximo 100) |
| `ExMon.Game.Status` | Imprime resultado de rodadas, game over e mensagens de vitória |

## Struct do Jogador

```elixir
%ExMon.Player{
  name: "Pikachu",
  life: 100,
  moves: %{
    move_rnd: :thunderbolt,   # dano alto
    move_avg: :tackle,        # dano médio
    move_heal: :potion        # restaura HP
  }
}
```

## Estado do Jogo

O Agent armazena um mapa com o estado atual de ambos os jogadores e de quem é o turno:

```elixir
%{
  player: %Player{},
  computer: %Player{},
  turn: :player | :computer,
  status: :started | :game_over
}
```

## Conceitos Praticados

- OTP `Agent` para manter estado mutável entre chamadas de função
- Definição e uso de structs
- Pattern matching para fluxo de controle
- Dano aleatório com `Enum.random/1`
- Design modular com módulos de ação distintos

## Como Executar

```elixir
iex -S mix

player = ExMon.create_player("Ash", :thunderbolt, :tackle, :potion)
ExMon.start_game(player)
ExMon.make_move(:move_rnd)
ExMon.make_move(:move_heal)
```

