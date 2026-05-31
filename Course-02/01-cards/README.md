# Cards

Biblioteca de manipulação de baralho que introduz padrões de programação funcional em Elixir: transformações puras, operações em listas, serialização binária baseada em Erlang e documentação com ExDoc.

A biblioteca modela um baralho padrão de cartas com suporte a embaralhar, distribuir, salvar e carregar.

## Arquitetura

Toda a lógica está em um único módulo `Cards`. Não há estado mutável — cada função recebe um baralho e retorna um novo.

```
create_deck/0
    |
    v
  ["Ace of Spades", "Two of Spades", ...]   # 20 cartas (5 valores x 4 naipes)
    |
    +-- shuffle/1         ->  baralho embaralhado
    +-- contains?/2       ->  true | false
    +-- deal/2            ->  {mão, restante}
    +-- save/1            ->  escreve arquivo binário em disco
    +-- load/1            ->  lê arquivo binário do disco
    +-- create_hand/2     ->  create -> shuffle -> deal (função de conveniência)
```

## Módulo

| Função | Descrição |
|---|---|
| `create_deck/0` | Gera todas as 20 cartas via compreensão aninhada (produto cartesiano de valores e naipes) |
| `shuffle/1` | Embaralha a ordem das cartas com `Enum.shuffle/1` |
| `contains?/2` | Retorna `true` se uma carta específica estiver no baralho |
| `deal/2` | Divide o baralho em `{mão, restante}` com `Enum.split/2` |
| `save/1` | Serializa o baralho com `:erlang.term_to_binary/1` e grava em arquivo |
| `load/1` | Lê e desserializa o baralho; retorna mensagem de erro se o arquivo não existir |
| `create_hand/2` | Compõe `create_deck -> shuffle -> deal` em uma única chamada |

## Conceitos Praticados

- Compreensões de lista com `for` para produto cartesiano
- Pipe operator `|>` para compor transformações
- Pattern matching no resultado de leitura de arquivo
- Serialização de termos Erlang (`:erlang.term_to_binary`, `:erlang.binary_to_term`)
- Documentação com ExDoc usando `@doc` e exemplos

## Como Executar

```elixir
iex -S mix

deck = Cards.create_deck()
deck = Cards.shuffle(deck)
{hand, _rest} = Cards.deal(deck, 5)
IO.inspect(hand)

# Salvar e recarregar
Cards.save(deck)
Cards.load("my_deck")
```

## Formato do Arquivo Salvo

O arquivo salvo é um binário Erlang puro (não legível). É recarregado com `:erlang.binary_to_term/1`. O nome padrão do arquivo é `"my_deck"`.

