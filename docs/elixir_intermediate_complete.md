# Elixir Intermediate — Handbook Completo

## 1. Processos

Processos BEAM são extremamente leves (~2 KB de heap inicial). Milhões podem coexistir.
Cada processo tem seu próprio heap, mailbox e pilha de chamadas — sem estado compartilhado.

```elixir
# Criar processo
pid = spawn(fn -> IO.puts("Hello from #{inspect(self())}") end)

# Ou via módulo e função
pid = spawn(MyWorker, :run, [arg1, arg2])

# PID do processo atual
self()   # #PID<0.123.0>

# Informações
Process.alive?(pid)           # true / false
Process.info(pid)             # keyword list completo
Process.info(pid, :memory)    # {:memory, bytes}
Process.info(pid, :message_queue_len)

# Encerrar
Process.exit(pid, :kill)      # força terminação (não pode ser capturada)
Process.exit(pid, :shutdown)  # terminação graciosa
Process.sleep(1_000)          # aguarda ms (só em testes/scripts)
```

---

## 2. Mensagens

```elixir
# Enviar
send(pid, {:hello, "mundo"})
send(self(), :ping)

# Receber — bloqueia até casar uma mensagem
receive do
  {:hello, msg}  -> IO.puts("Recebido: #{msg}")
  :ping          -> :pong
  other          -> IO.inspect(other)
after
  5_000 -> {:error, :timeout}   # timeout em ms
end
```

Mensagens ficam na mailbox até serem consumidas. Nunca drops silenciosos.
Use `flush()` no IEx para ver mensagens pendentes.

---

## 3. Links e Monitors

### Links — propagação bidirecional de falhas

```elixir
# Ao criar: se filho morrer, pai também morre (e vice-versa)
pid = spawn_link(fn -> raise "boom" end)

# Capturar saídas de processos linkados
Process.flag(:trap_exit, true)
pid = spawn_link(fn -> exit(:my_reason) end)

receive do
  {:EXIT, ^pid, :normal}    -> IO.puts("saiu normalmente")
  {:EXIT, ^pid, reason}     -> IO.puts("morreu: #{inspect(reason)}")
end

# Criar link depois
Process.link(pid)
Process.unlink(pid)
```

### Monitors — observação unidirecional

```elixir
ref = Process.monitor(pid)

receive do
  {:DOWN, ^ref, :process, pid, :normal}  -> IO.puts("saiu")
  {:DOWN, ^ref, :process, pid, reason}   -> IO.puts("morreu: #{inspect(reason)}")
end

# Cancelar
Process.demonitor(ref)
Process.demonitor(ref, [:flush])   # descarta mensagem :DOWN pendente
```

**Link vs Monitor:**
- Link: bidirecional, propaga falhas, processos viram irmãos
- Monitor: unidirecional, apenas notifica, ideal para observers

---

## 4. Task

Abstração de alto nível para tarefas assíncronas.

```elixir
# Fire-and-forget
Task.start(fn -> heavy_computation() end)

# Com resultado (async/await)
task = Task.async(fn -> heavy_computation() end)
result = Task.await(task)              # aguarda indefinidamente
result = Task.await(task, 10_000)      # timeout em ms (padrão: 5_000)

# Múltiplas em paralelo
tasks = Enum.map(urls, fn url ->
  Task.async(fn -> fetch(url) end)
end)
results = Task.await_many(tasks, 15_000)

# yield — não levanta exceção no timeout
case Task.yield(task, 5_000) do
  {:ok, result} -> result
  nil           ->
    Task.shutdown(task)
    {:error, :timeout}
end

# yield_many — múltiplas com timeout único
tasks
|> Task.yield_many(10_000)
|> Enum.map(fn {task, result} ->
  case result do
    {:ok, val} -> val
    nil        -> Task.shutdown(task); nil
  end
end)
```

### Task.Supervisor

```elixir
# Em Application ou Supervisor
{Task.Supervisor, name: MyApp.TaskSupervisor}

# Uso
Task.Supervisor.async(MyApp.TaskSupervisor, fn ->
  heavy_work()
end)

Task.Supervisor.start_child(MyApp.TaskSupervisor, fn ->
  fire_and_forget()
end)

# async_stream — paralelismo controlado
MyApp.TaskSupervisor
|> Task.Supervisor.async_stream(items, &process/1,
  max_concurrency: 10,
  timeout: 5_000,
  on_timeout: :kill_task
)
|> Enum.to_list()
```

---

## 5. Agent

Estado simples em um processo separado. Use para caches e contadores leves.

```elixir
{:ok, agent} = Agent.start_link(fn -> %{} end)
{:ok, _}     = Agent.start_link(fn -> [] end, name: :my_cache)

# Ler
Agent.get(agent, fn state -> state end)
Agent.get(agent, & &1)
Agent.get(:my_cache, &Map.get(&1, :key))

# Atualizar
Agent.update(agent, fn state -> Map.put(state, :key, "value") end)
Agent.update(agent, &Map.put(&1, :key, "value"))

# Ler e atualizar atomicamente
Agent.get_and_update(agent, fn state ->
  {state[:count], Map.update(state, :count, 1, &(&1 + 1))}
end)

Agent.stop(agent)
Agent.stop(agent, :normal, 5_000)
```

---

## 6. GenServer

Servidor de processos genérico. Base de toda a OTP. Encapsula estado + comportamento.

```elixir
defmodule Counter do
  use GenServer

  # ---- API pública ----

  def start_link(initial \ 0) do
    GenServer.start_link(__MODULE__, initial, name: __MODULE__)
  end

  def increment(amount \ 1),  do: GenServer.cast(__MODULE__, {:inc, amount})
  def decrement(amount \ 1),  do: GenServer.cast(__MODULE__, {:dec, amount})
  def value,                   do: GenServer.call(__MODULE__, :value)
  def reset,                   do: GenServer.call(__MODULE__, :reset)

  # ---- Callbacks ----

  @impl true
  def init(initial) do
    {:ok, initial}
    # Opções: {:ok, state, timeout_ms}
    #         {:ok, state, :hibernate}
    #         {:stop, reason}
  end

  @impl true
  def handle_call(:value, _from, state) do
    {:reply, state, state}
    # {:reply, reply, new_state}
    # {:reply, reply, new_state, timeout_ms}
    # {:noreply, new_state}  (responde via GenServer.reply/2 depois)
    # {:stop, reason, reply, new_state}
  end

  def handle_call(:reset, _from, _state) do
    {:reply, :ok, 0}
  end

  @impl true
  def handle_cast({:inc, amount}, state) do
    {:noreply, state + amount}
    # {:noreply, new_state}
    # {:noreply, new_state, timeout_ms}
    # {:stop, reason, new_state}
  end

  def handle_cast({:dec, amount}, state) do
    {:noreply, state - amount}
  end

  @impl true
  def handle_info(:tick, state) do
    # Mensagens via send/2, Process.send_after, :erlang.send_after
    Process.send_after(self(), :tick, 1_000)
    {:noreply, state}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  @impl true
  def terminate(reason, state) do
    # Limpeza antes de encerrar
    IO.puts("Terminando: #{inspect(reason)}, estado: #{state}")
    :ok
  end

  @impl true
  def code_change(_old_vsn, state, _extra) do
    # Hot code reload
    {:ok, state}
  end
end
```

### Uso

```elixir
{:ok, _pid} = Counter.start_link(10)
Counter.increment()
Counter.increment(5)
Counter.value()          # 16
Counter.reset()
Counter.value()          # 0

# call com timeout customizado
GenServer.call(pid, :value, 10_000)

# Parar
GenServer.stop(Counter)
GenServer.stop(Counter, :normal, 5_000)
```

### Tabela de retornos

| Callback | Retornos principais |
|---|---|
| `init/1` | `{:ok, state}`, `{:ok, state, timeout}`, `{:stop, reason}` |
| `handle_call/3` | `{:reply, reply, state}`, `{:noreply, state}`, `{:stop, reason, reply, state}` |
| `handle_cast/2` | `{:noreply, state}`, `{:stop, reason, state}` |
| `handle_info/2` | `{:noreply, state}`, `{:stop, reason, state}` |

---

## 7. Supervisor

Gerencia o ciclo de vida de processos filhos.

```elixir
defmodule MyApp.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    children = [
      Counter,                                           # usa child_spec padrão
      {MyWorker, arg: :value},                          # passa opções
      {Task.Supervisor, name: MyApp.TaskSupervisor},
      Supervisor.child_spec({Cache, []}, id: :main_cache)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
```

### Estratégias

| Estratégia | Comportamento |
|---|---|
| `:one_for_one` | Reinicia apenas o processo que morreu (padrão) |
| `:one_for_all` | Reinicia todos os filhos se qualquer um morrer |
| `:rest_for_one` | Reinicia o processo falho e todos iniciados após ele |

### child_spec customizado

```elixir
def child_spec(opts) do
  %{
    id: __MODULE__,
    start: {__MODULE__, :start_link, [opts]},
    restart: :permanent,     # :permanent | :transient | :temporary
    shutdown: 5_000,         # ms para shutdown gracioso, ou :infinity, ou :brutal_kill
    type: :worker            # :worker | :supervisor
  }
end
```

- `:permanent` — sempre reinicia (default)
- `:transient` — reinicia apenas se terminar anormalmente
- `:temporary` — nunca reinicia

### Limites de reinicialização

```elixir
Supervisor.init(children,
  strategy: :one_for_one,
  max_restarts: 3,    # máximo de reinicializações
  max_seconds: 5      # dentro deste período (padrão: 3 em 5s)
)
# Se exceder, o próprio supervisor para
```

### DynamicSupervisor

Para criar e remover filhos em runtime.

```elixir
defmodule MyApp.WorkerSupervisor do
  use DynamicSupervisor

  def start_link(_), do: DynamicSupervisor.start_link(__MODULE__, nil, name: __MODULE__)

  @impl true
  def init(_), do: DynamicSupervisor.init(strategy: :one_for_one)

  def start_worker(args) do
    DynamicSupervisor.start_child(__MODULE__, {Worker, args})
  end

  def stop_worker(pid) do
    DynamicSupervisor.terminate_child(__MODULE__, pid)
  end
end

DynamicSupervisor.count_children(MyApp.WorkerSupervisor)
# %{active: 3, specs: 3, supervisors: 0, workers: 3}
```

---

## 8. Application

Unidade deployável OTP. Define a árvore de supervisão raiz.

```elixir
defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyApp.Repo,
      {Phoenix.PubSub, name: MyApp.PubSub},
      MyAppWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def stop(_state), do: :ok
end
```

`mix.exs`:

```elixir
def application do
  [
    mod: {MyApp.Application, []},
    extra_applications: [:logger, :crypto, :runtime_tools]
  ]
end
```

---

## 9. ETS

Erlang Term Storage. Tabela em memória compartilhada entre processos. Acesso O(1) para `:set`.

```elixir
# Criar
:ets.new(:cache, [:set, :public, :named_table])
:ets.new(:counters, [:set, :public, :named_table, {:write_concurrency, true}])

# Inserir
:ets.insert(:cache, {:key, "value"})
:ets.insert(:cache, [{"k1", 1}, {"k2", 2}])    # batch

# Consultar
:ets.lookup(:cache, :key)                        # [{:key, "value"}]
:ets.lookup_element(:cache, :key, 2)             # "value"  (posição 1-based)
:ets.member(:cache, :key)                        # true

# Atualizar contador atomicamente
:ets.update_counter(:cache, :visits, 1)
:ets.update_counter(:cache, :visits, {2, 1, 100, 0})  # {pos, inc, threshold, reset}

# Deletar
:ets.delete(:cache, :key)
:ets.delete_all_objects(:cache)
:ets.delete(:cache)    # remove a tabela

# Iteração e busca
:ets.tab2list(:cache)                            # todos os registros
:ets.match(:cache, {:_, :"$1"})                  # match (retorna bindings)
:ets.match_object(:cache, {:_, "value"})         # registros completos
:ets.select(:cache, [
  {{:"$1", :"$2"}, [{:>, :"$2", 5}], [{{:"$1", :"$2"}}]}
])                                               # match spec

# Informações
:ets.info(:cache)
:ets.info(:cache, :size)
```

### Tipos de tabela

| Tipo | Chaves | Duplicatas |
|---|---|---|
| `:set` | únicas | não |
| `:ordered_set` | únicas, ordenadas | não |
| `:bag` | duplicadas | valores distintos |
| `:duplicate_bag` | duplicadas | valores iguais permitidos |

### Acessos

| Acesso | Quem pode ler | Quem pode escrever |
|---|---|---|
| `:private` | processo criador | processo criador |
| `:protected` | qualquer | processo criador |
| `:public` | qualquer | qualquer |

---

## 10. Protocols

Polimorfismo baseado em tipo de dado. Similar a type classes / interfaces.

```elixir
defprotocol Stringify do
  @doc "Converte para string representacional"
  @spec to_string(t) :: String.t()
  def to_string(value)
end

defimpl Stringify, for: Integer do
  def to_string(n), do: "Int(#{n})"
end

defimpl Stringify, for: List do
  def to_string(l), do: "[#{Enum.count(l)} items]"
end

defimpl Stringify, for: Map do
  def to_string(m), do: "{#{Map.keys(m) |> Enum.join(", ")}}"
end

# Fallback para qualquer tipo
defimpl Stringify, for: Any do
  def to_string(v), do: inspect(v)
end

# No defprotocol, habilitar fallback:
defprotocol MyProto do
  @fallback_to_any true
  def process(t)
end
```

Uso:

```elixir
Stringify.to_string(42)        # "Int(42)"
Stringify.to_string([1,2,3])   # "[3 items]"
```

---

## 11. Behaviours

Contratos (callbacks obrigatórios) para módulos. Similar a interfaces.

```elixir
defmodule Storage do
  @doc "Busca um valor pela chave"
  @callback get(key :: term()) :: {:ok, term()} | {:error, term()}

  @doc "Armazena um par chave-valor"
  @callback put(key :: term(), value :: term()) :: :ok | {:error, term()}

  @doc "Remove uma chave"
  @callback delete(key :: term()) :: :ok

  @optional_callbacks [delete: 1]
end

defmodule EtsStorage do
  @behaviour Storage

  @impl Storage
  def get(key) do
    case :ets.lookup(:store, key) do
      [{^key, val}] -> {:ok, val}
      []            -> {:error, :not_found}
    end
  end

  @impl Storage
  def put(key, value) do
    :ets.insert(:store, {key, value})
    :ok
  end

  @impl Storage
  def delete(key) do
    :ets.delete(:store, key)
    :ok
  end
end
```

`@impl true` faz o compilador validar que a função implementa um callback declarado.

---

## 12. Tratamento de Erros

```elixir
# Convenção {:ok, value} / {:error, reason}
case fetch_data(id) do
  {:ok, data}      -> process(data)
  {:error, reason} -> handle(reason)
end

# raise / rescue
try do
  raise ArgumentError, message: "inválido"
rescue
  e in ArgumentError        -> {:error, e.message}
  e in [RuntimeError, KeyError] -> {:error, inspect(e)}
  _ -> reraise "inesperado", __STACKTRACE__
after
  cleanup()    # sempre executa
end

# throw / catch — controle de fluxo (raro, evitar)
try do
  Enum.each(items, fn item ->
    if item == :stop, do: throw(:found)
  end)
  :not_found
catch
  :found -> :found
end

# exit
try do
  exit(:shutdown)
catch
  :exit, reason -> IO.puts("exit: #{inspect(reason)}")
end

# Reraising com stacktrace original
try do
  dangerous()
rescue
  e ->
    Logger.error(Exception.format(:error, e, __STACKTRACE__))
    reraise e, __STACKTRACE__
end
```

### Filosofia OTP

Prefira "let it crash": deixe o Supervisor reiniciar.
Use `try/rescue` apenas nos boundaries do sistema (ex: controllers, plugs, scripts).

---

## 13. Typespecs

```elixir
defmodule Calculator do
  @type result :: {:ok, number()} | {:error, String.t()}

  @spec add(number(), number()) :: number()
  def add(a, b), do: a + b

  @spec divide(number(), number()) :: result()
  def divide(_, 0), do: {:error, "divisão por zero"}
  def divide(a, b), do: {:ok, a / b}
end

# Tipos para structs
defmodule User do
  @type t :: %__MODULE__{
    id: pos_integer(),
    name: String.t(),
    email: String.t(),
    role: :admin | :viewer | :editor
  }

  defstruct [:id, :name, :email, role: :viewer]
end
```

### Tipos built-in

```elixir
term()              # qualquer valor
any()               # alias de term
none()              # função que nunca retorna
atom()
binary()            # string
boolean()
float()
integer()
non_neg_integer()
pos_integer()
neg_integer()
list()
list(t)             # list tipada
nonempty_list(t)
maybe_improper_list()
map()
struct()
tuple()
fun()
pid()
port()
reference()
node()
number()            # integer | float
timeout()           # non_neg_integer | :infinity
{t1, t2}            # tupla tipada
%{key: type}        # map tipado
```

### Dialyzer

```bash
# mix.exs
{:dialyxir, "~> 1.4", only: [:dev], runtime: false}

# Executar
mix dialyzer
mix dialyzer --format dialyxir
```

---

## 14. Mix Essencial

```bash
# Criar projeto
mix new my_app
mix new my_app --sup    # com Application + Supervisor
mix phx.new my_app      # Phoenix

# Dependências
mix deps.get
mix deps.compile
mix deps.update dep_name
mix deps.update --all
mix deps.clean dep_name
mix deps.tree

# Compilação
mix compile
mix compile --force
mix compile --warnings-as-errors

# Testes
mix test
mix test test/my_test.exs
mix test test/my_test.exs:42
mix test --only integration
mix test --cover

# IEx com projeto
iex -S mix
iex -S mix phx.server

# Formatação
mix format
mix format --check-formatted

# Documentação
mix docs     # gera com ExDoc
```

### Aliases no mix.exs

```elixir
defp aliases do
  [
    setup: ["deps.get", "ecto.setup"],
    "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
    test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
  ]
end
```
