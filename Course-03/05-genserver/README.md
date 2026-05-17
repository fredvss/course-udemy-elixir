# 05 - GenServer

`GenServer` (Generic Server) é um comportamento OTP que padroniza a implementação de processos stateful em Elixir. Ele abstrai o loop de mensagens e o gerenciamento de estado, deixando o desenvolvedor focado apenas na lógica de negócio.

## Como funciona

Um `GenServer` roda em um processo separado. O estado é mantido pelo próprio processo e só é acessado através das funções de interface (call/cast/info). Toda comunicação é via troca de mensagens.

```
Client                          GenServer Process
  |                                   |
  |-- GenServer.call(:get) ---------> |
  |                                   | handle_call(:get, from, state)
  |<-- {:reply, value, state} -------|
  |                                   |
  |-- GenServer.cast(:update) ------> |
  |                                   | handle_cast(:update, state)
  |   (sem resposta)                  | {:noreply, new_state}
```

## Callbacks principais

### `init/1`

Chamado quando o processo é iniciado via `GenServer.start/3` ou `GenServer.start_link/3`. Define o estado inicial.

| Retorno | Significado |
|---------|-------------|
| `{:ok, state}` | Inicia com sucesso |
| `{:ok, state, timeout}` | Inicia e agenda um timeout |
| `{:stop, reason}` | Aborta a inicialização |

```elixir
def init(initial_value) do
  {:ok, initial_value}
end
```

---

### `handle_call/3`

Trata mensagens **síncronas** (o cliente fica bloqueado aguardando resposta). Recebe `(request, from, state)`.

| Retorno | Significado |
|---------|-------------|
| `{:reply, response, new_state}` | Responde ao cliente e atualiza estado |
| `{:noreply, new_state}` | Não responde imediatamente (resposta manual via `GenServer.reply/2`) |
| `{:stop, reason, response, new_state}` | Responde e para o servidor |

```elixir
# Servidor
def handle_call(:get_value, _from, state) do
  {:reply, state, state}
end

# Cliente
GenServer.call(pid, :get_value)
```

---

### `handle_cast/2`

Trata mensagens **assíncronas** (o cliente não aguarda resposta). Recebe `(request, state)`.

| Retorno | Significado |
|---------|-------------|
| `{:noreply, new_state}` | Atualiza estado sem responder |
| `{:stop, reason, new_state}` | Para o servidor |

```elixir
# Servidor
def handle_cast({:add, value}, state) do
  {:noreply, state + value}
end

# Cliente
GenServer.cast(pid, {:add, 10})
```

---

### `handle_info/2`

Trata **qualquer mensagem** enviada diretamente ao processo (não via `call` ou `cast`), como timeouts, mensagens de processos monitorados (`{:DOWN, ...}`), respostas de ports, etc.

```elixir
# Mensagem de processo morto (via monitor)
def handle_info({:DOWN, _ref, :process, pid, reason}, state) do
  IO.puts("Processo #{inspect(pid)} morreu: #{inspect(reason)}")
  {:noreply, state}
end

# Timeout configurado no init
def handle_info(:timeout, state) do
  IO.puts("Timeout!")
  {:noreply, state}
end
```

---

### `terminate/2`

Chamado antes do processo parar (quando supervisionado ou parado explicitamente). Útil para limpeza de recursos.

> Atenção: só é chamado de forma confiável quando o processo está sob um Supervisor com `trap_exit: true`.

```elixir
def terminate(reason, state) do
  IO.puts("Encerrando. Razão: #{inspect(reason)}, Estado: #{inspect(state)}")
  :ok
end
```

---

### `code_change/3`

Chamado durante hot code upgrades (atualização de código em produção sem parar o servidor). Recebe `(old_vsn, state, extra)`.

```elixir
def code_change(_old_vsn, state, _extra) do
  {:ok, state}
end
```

---

## Resumo das callbacks

| Callback | Disparado por | Tipo | Retorno principal |
|----------|--------------|------|-------------------|
| `init/1` | `start/start_link` | — | `{:ok, state}` |
| `handle_call/3` | `GenServer.call/2,3` | Síncrono | `{:reply, resp, state}` |
| `handle_cast/2` | `GenServer.cast/2` | Assíncrono | `{:noreply, state}` |
| `handle_info/2` | mensagem direta ao processo | — | `{:noreply, state}` |
| `terminate/2` | shutdown / stop | — | `:ok` |
| `code_change/3` | hot upgrade | — | `{:ok, new_state}` |

---

## Exemplo completo mínimo

```elixir
defmodule Counter do
  use GenServer

  # Interface
  def start_link(initial \\ 0), do: GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  def increment,                do: GenServer.cast(__MODULE__, :increment)
  def value,                    do: GenServer.call(__MODULE__, :value)

  # Callbacks
  def init(n),                              do: {:ok, n}
  def handle_cast(:increment, n),           do: {:noreply, n + 1}
  def handle_call(:value, _from, n),        do: {:reply, n, n}
  def terminate(reason, _state),            do: IO.puts("Stopped: #{inspect(reason)}")
end

{:ok, _pid} = Counter.start_link(0)
Counter.increment()
Counter.increment()
Counter.value() |> IO.inspect()  # => 2
```

---

## Exemplos nesta seção

| Pasta | Conteúdo | Callbacks usados |
|-------|----------|-----------------|
| `genserver-intro` | Primeiro GenServer, estado inicial | `init/1` |
| `genserver-init-validation` | Validação do estado inicial com guards | `init/1` |
| `genserver-calculator` | Calculadora stateful | `init/1`, `handle_call/3`, `handle_cast/2`, `terminate/2` |
| `game-of-stones` | Jogo interativo com cliente e servidor | `init/1`, `handle_call/3`, `terminate/2` |

---

## Comandos úteis

```bash
# Rodar um arquivo de exemplo
elixir genserver_intro.exs

# Abrir o IEx com um arquivo carregado
iex genserver_intro.exs

# Iniciar um GenServer no IEx
iex> {:ok, pid} = GenServer.start(MyModule, :initial_state)
iex> GenServer.call(pid, :some_request)
iex> GenServer.cast(pid, :some_message)
iex> GenServer.stop(pid)

# Ver o estado atual de um GenServer (debug)
iex> :sys.get_state(pid)

# Ver estatísticas do processo
iex> :sys.statistics(pid, true)
iex> :sys.statistics(pid, :get)
```
