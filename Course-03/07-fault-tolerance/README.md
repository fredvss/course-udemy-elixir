# 07 - Fault Tolerance

Tolerância a falhas é um dos pilares do Elixir/OTP. Em vez de tentar prevenir todas as falhas, o OTP adota a filosofia **"let it crash"**: deixa os processos falharem e os reinicia automaticamente por meio de supervisores.

## Application

Um projeto Mix com `--sup` (ou com `mod:` em `mix.exs`) define um **Application behaviour**. O OTP chama `start/2` automaticamente quando a aplicação sobe.

```elixir
# lib/application.ex
defmodule MyApp.Application do
  use Application

  def start(_type, _args) do
    children = [MyApp.Server]
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

```elixir
# mix.exs
def application do
  [mod: {MyApp.Application, []}, extra_applications: [:logger]]
end
```

## Supervisor

O `Supervisor` monitora processos filhos e os reinicia quando falham.

```elixir
Supervisor.start_link(children, opts)
```

### Estratégias de reinício

| Estratégia | Comportamento ao falhar um filho |
|---|---|
| `:one_for_one` | Reinicia apenas o processo que falhou |
| `:one_for_all` | Reinicia **todos** os filhos |
| `:rest_for_one` | Reinicia o que falhou e todos os que foram iniciados **depois** dele |

### `start_link` vs `start`

| Função | Vincula ao processo pai? | Uso típico |
|--------|--------------------------|------------|
| `GenServer.start_link/3` | Sim | Dentro de um Supervisor |
| `GenServer.start/3` | Não | Scripts, testes, processos avulsos |

Use `start_link/3` para que o Supervisor detecte e reinicie o processo ao falhar.

## Child spec

Cada filho pode ser especificado como módulo (usa o `child_spec/1` padrão) ou como mapa explícito:

```elixir
children = [
  MyApp.Server,                              # usa child_spec padrão
  {MyApp.Worker, arg},                       # passa argumento para init/1
  %{id: :custom, start: {Mod, :start_link, [args]}}  # spec manual
]
```

## ETS (Erlang Term Storage)

ETS é uma tabela em memória do Erlang — muito mais rápida que um GenServer para leituras concorrentes. Usada para persistir estado entre reinícios do processo.

```elixir
# criar tabela (normalmente no Storage.init/1)
table = :ets.new(:my_table, [:set, :public, :named_table])

# escrever
:ets.insert(:my_table, {:key, value})

# ler
case :ets.lookup(:my_table, :key) do
  [{:key, value}] -> {:ok, value}
  []              -> :not_found
end

# deletar
:ets.delete(:my_table, :key)
```

Como a tabela ETS pertence ao processo que a criou, é comum isolá-la em um **Storage GenServer** supervisionado separadamente do Server que usa os dados.

## Projetos desta seção

| Pasta | Conteúdo |
|-------|----------|
| `game_of_stones_supervised/` | Game of Stones com Supervisor: Server reinicia automaticamente ao falhar |
| `game_of_stones_ets/` | Evolução com ETS: estado do jogo sobrevive ao reinício do Server |
