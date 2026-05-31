# Identicon

Gera identicons visuais determinísticos a partir de texto. A mesma string sempre produz a mesma imagem PNG de 250x250 pixels, útil para gerar avatares baseados em nomes de usuário ou outros identificadores.

A implementação demonstra um pipeline puro de transformação de dados usando structs Elixir, hash MD5 via módulo Erlang `:crypto` e renderização de imagem via `:egd`.

## Pipeline

```
string de entrada
    |
    v
hash_input/1       -- MD5 via :crypto.hash -> lista de 16 inteiros
    |
    v
pick_color/1       -- primeiros 3 bytes viram {r, g, b}
    |
    v
build_grid/1       -- organiza em grade 5x5, espelha cada linha (col 4 = col 2, col 5 = col 1)
    |
    v
filter_odd_squares/1  -- mantém apenas células com valores pares (os quadrados coloridos)
    |
    v
build_pixel_map/1  -- converte índice da grade em coordenadas de pixel (cada célula = 50x50 px)
    |
    v
draw_image/1       -- renderiza os pixels com :egd usando a cor escolhida
    |
    v
save_image/2       -- grava o arquivo PNG em disco
```

## Estrutura de Dados

Um único struct acumula os dados ao longo do pipeline:

```elixir
%Identicon.Image{
  hex:       [int, ...],            # 16 bytes do MD5
  color:     {r, g, b},             # tupla RGB
  grid:      [{value, index}, ...], # 25 células
  pixel_map: [{{x1,y1}, {x2,y2}}, ...] # 25 pares de coordenadas
}
```

## Layout da Imagem

- Tamanho de saída: 250x250 pixels
- Grade: 5 colunas x 5 linhas, cada célula com 50x50 px
- Simetria: a grade é espelhada horizontalmente (apenas 3 colunas únicas)
- Coloração: células com valores pares do hash são preenchidas; células ímpares ficam brancas

## Conceitos Praticados

- Arquitetura de pipeline com `|>` e struct acumulador
- Interop com Erlang: `:crypto`, `:egd`, `:erlang.binary`
- Agrupamento de listas com `Enum.chunk_every/2`
- Cálculo de coordenadas baseado em índice
- Saída determinística a partir de funções de hash

## Como Executar

```elixir
iex -S mix

Identicon.main("banana")
# => grava "banana.png" no diretório atual
```

> Nota: `:egd` está deprecado em versões modernas do OTP. O projeto foi desenvolvido para fins de aprendizado e pode exigir uma versão mais antiga do OTP ou uma instalação compatível do `:egd`.

