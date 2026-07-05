# Elixir Advanced — Handbook Completo

## 1. BEAM VM Internals

### Arquitetura

```
┌─────────────────────────────────────────────┐
│                    BEAM                     │
│                                             │
│  Scheduler 0  Scheduler 1  ...  Scheduler N │
│  (run queue)  (run queue)       (run queue) │
│       │             │                 │     │
│  Process Pool (migração entre schedulers)   │
│                                             │
│  I/O Threads (async)  Timer Wheel           │
│  Port Drivers         Atom Table (global)   │
│  ETS / DETS           Code Server           │
└─────────────────────────────────────────────┘
```

Um scheduler por core por padrão.

```elixir
System.schedulers()           # número de schedulers
System.schedulers_online()    # schedulers ativos
:erlang.system_info(:schedulers)
:erlang.system_info(:process_count)
:erlang.system_info(:process_limit)
```

### Reductions (preempção)

Cada processo recebe um quantum de **reductions** (aprox. 2000 por vez).
Operações custam reductions (chamadas de função = 1 reduction).
Quando esgota, o scheduler suspende o processo e roda o próximo.

Isso garante **preempção cooperativa com fairness**: nenhum processo domina um core.

```elixir
# Ver reductions usadas por um processo
Process.info(pid, :reductions)   # {:reductions, 12345}
```

### Processo: memória e ciclo de vida

```
Heap inicial: ~233 words (~1.8 KB)
Heap máximo: sem limite por padrão (configurável)
GC: por processo, mark-and-copy
Mailbox: separada do heap
Stack: embutido no heap (cresce/encolhe)
```

```elixir
# Configurar heap mínimo / tamanho de mailbox
spawn_opt(fn -> work() end, [
  {:min_heap_size, 10_000},
  {:min_bin_vheap_size, 10_000},
  {:max_heap_size, 100_000},   # mata processo se ultrapassar
  {:priority, :high},           # :low | :normal | :high | :max
  {:fullsweep_after, 0}         # GC completo sempre
])
```

---

## 2. Garbage Collection

GC por processo elimina pausas globais (stop-the-world).

### Mark-and-Copy (generational)

1. Minor GC (young gen): copia objetos vivos para nova área — frequente, barato
2. Full GC (old gen): após `fullsweep_after` minor GCs — menos frequente

```elixir
:erlang.garbage_collect()           # força GC no processo atual
:erlang.garbage_collect(pid)        # força GC em outro processo

# Informações de memória
Process.info(self(), :memory)        # heap total
Process.info(self(), :heap_size)     # words no heap
Process.info(self(), :garbage_collection)
:erlang.memory()                     # memória total da VM
:erlang.memory(:processes)           # memória de todos os processos
:erlang.memory(:binary)              # binários ref-counted
```

### Binários: dois tipos

- **Heap binary** (< 64 bytes): vive no heap do processo, copiado normalmente
- **Ref-counted binary** (≥ 64 bytes): vive fora do heap, compartilhado por referência

```elixir
# Problema: processo que acumula referências a binários grandes
# mesmo sem usá-los → binary memory leak
:erlang.garbage_collect()    # força liberação de refs soltas
```

---

## 3. OTP Design Principles

### Lei de Demeter para processos

- Processos devem conhecer apenas seus filhos diretos
- Comunicação via mensagens, não referências de estado

### Árvore de supervisão

```
Application
└── Root Supervisor (:one_for_one)
    ├── Repo
    ├── PubSub
    ├── WorkerSupervisor (DynamicSupervisor)
    │   ├── Worker #1
    │   ├── Worker #2
    │   └── ...
    └── Endpoint
```

### Processo de inicialização síncrona

`init/1` do GenServer/Supervisor é síncrono: o processo pai aguarda retornar `{:ok, state}` antes de continuar.

```elixir
# init/1 pesado → use handle_continue
def init(args) do
  {:ok, nil, {:continue, {:load, args}}}
end

def handle_continue({:load, args}, _state) do
  state = heavy_init(args)
  {:noreply, state}
end
```

### Registry

Registro de processos nomeados sem atom global.

```elixir
# Em Application
{Registry, keys: :unique, name: MyApp.Registry}

# Registrar
Registry.register(MyApp.Registry, "room:42", %{})

# Buscar
Registry.lookup(MyApp.Registry, "room:42")
# [{pid, %{}}]

# Via DynamicSupervisor + Registry
{:via, Registry, {MyApp.Registry, name}}
```

---

## 4. Distribuição

Nodes BEAM se comunicam nativamente via Erlang Distribution Protocol.

### Iniciar nodes

```bash
# Node com nome longo
iex --name alice@192.168.1.10 --cookie secret_cookie

# Node com nome curto
iex --sname alice --cookie secret_cookie
```

```elixir
# Informações
node()                    # :nonode@nohost (ou nome do node)
Node.self()               # mesmo que node()
Node.list()               # nodes conectados
Node.alive?()             # se node está distribuído

# Conectar
Node.connect(:"bob@192.168.1.11")
Node.ping(:"bob@192.168.1.11")     # :pong | :pang
Node.disconnect(:"bob@192.168.1.11")
```

### Enviar mensagens entre nodes

```elixir
# send para pid em outro node
send({:some_process, :"bob@192.168.1.11"}, :hello)

# :rpc — chamadas síncronas remotas
:rpc.call(:"bob@192.168.1.11", MyModule, :function, [arg1, arg2])
:rpc.cast(:"bob@192.168.1.11", MyModule, :function, [args])    # async

# Multicast
:rpc.multicall(nodes, MyModule, :function, [args])
```

### Global registry

```elixir
# Registrar nome global (visível em todo o cluster)
:global.register_name(:my_server, self())
:global.whereis_name(:my_server)    # pid | :undefined
:global.unregister_name(:my_server)
```

### :pg — Process Groups (recomendado)

```elixir
# Em Application
:pg.start_link()

# Entrar em grupo
:pg.join(:my_group, self())

# Sair
:pg.leave(:my_group, self())

# Listar membros (todos os nodes)
:pg.get_members(:my_group)
:pg.get_local_members(:my_group)
```

---

## 5. Hot Code Reload

BEAM suporta upgrade de código em produção sem downtime.

### Mecanismo

```elixir
# Dois módulos podem coexistir: "current" e "old"
# Chamadas qualificadas (Module.fun) usam "current"
# Chamadas não-qualificadas usam a versão que chamou

# Forçar upgrade via IEx
r(MyModule)    # recompila e recarrega

# Programático
:code.load_file(MyModule)
:code.purge(MyModule)    # remove versão "old"
:code.soft_purge(MyModule)  # só purga se nenhum processo usa
```

### OTP Release Upgrade

```elixir
# @vsn no módulo — versão para hot reload
defmodule MyServer do
  @vsn "2"
  use GenServer

  # Migração de estado ao atualizar versão
  def code_change("1", old_state, _extra) do
    new_state = migrate_v1_to_v2(old_state)
    {:ok, new_state}
  end
end
```

```bash
# Gerar release
mix release

# Upgrade
bin/my_app upgrade "2.0.0"
```

---

## 6. NIFs e Ports

### NIFs (Native Implemented Functions)

Código C/Rust chamado diretamente pelo processo BEAM. **Perigoso**: crash derruba a VM.

```elixir
defmodule MyNif do
  @on_load :load_nif

  def load_nif do
    path = :filename.join(:code.priv_dir(:my_app), "my_nif")
    :erlang.load_nif(path, 0)
  end

  # stub substituído pelo NIF em runtime
  def fast_hash(_data), do: raise("NIF não carregado")
end
```

Use [Rustler](https://github.com/rusterlium/rustler) para NIFs em Rust com mais segurança.

### Ports

Comunicação com processos OS externos. O processo externo não pode crashar a VM.

```elixir
port = Port.open({:spawn, "python3 script.py"}, [:binary])

# Enviar dados
send(port, {self(), {:command, "input data
"}})

# Receber dados
receive do
  {^port, {:data, output}} -> IO.puts(output)
  {^port, :closed}         -> IO.puts("processo encerrado")
end

Port.close(port)
Port.info(port)
```

---

## 7. Performance

### Regras gerais

1. **Mensagens**: evite passar dados grandes entre processos (cópia)
2. **ETS**: prefira para estado compartilhado (sem cópia, shared ref-counted binaries)
3. **Binários**: concatenação com `<>` cria novo binário — use `IO.iodata_to_binary/1` para builds
4. **Lists vs Tuples**: lista = linked list (O(n) acesso), tuple = array (O(1) acesso)
5. **Maps grandes**: use `:ets` ou `Map` com chaves atômicas
6. **Processos**: criar/destruir é barato, mas muitos acumulados consomem memória

### Benchmarking com Benchee

```elixir
# mix.exs: {:benchee, "~> 1.3", only: :dev}

Benchee.run(
  %{
    "lista" => fn -> Enum.map(list, &process/1) end,
    "stream" => fn -> Stream.map(list, &process/1) |> Enum.to_list() end
  },
  time: 5,
  memory_time: 2,
  warmup: 2
)
```

### Profiling

```elixir
# :eprof — profiling de tempo (por função)
:eprof.start_profiling([self()])
heavy_work()
:eprof.stop_profiling()
:eprof.analyze()

# :fprof — profiling detalhado (grava tudo, mais overhead)
:fprof.apply(&heavy_work/0, [])
:fprof.profile()
:fprof.analyse(dest: "/tmp/profile.txt")

# :cprof — profiling de call counts (mínimo overhead)
:cprof.start()
heavy_work()
:cprof.pause()
:cprof.analyse(MyModule)

# ExProf (wrapper mais amigável)
# {:ex_prof, "~> 0.4"}
```

### :timer

```elixir
:timer.tc(fn -> heavy_work() end)
# {microseconds, result}

:timer.tc(MyModule, :function, [args])
```

---

## 8. Telemetry

Sistema de instrumentação baseado em eventos. Padrão no ecossistema Elixir/Phoenix.

```elixir
# mix.exs: {:telemetry, "~> 1.2"}

# Emitir evento
:telemetry.execute(
  [:my_app, :request, :stop],
  %{duration: 123},                      # measurements
  %{path: "/users", status: 200}         # metadata
)

# Anexar handler
:telemetry.attach(
  "my-handler",
  [:my_app, :request, :stop],
  fn event, measurements, metadata, config ->
    IO.inspect({event, measurements, metadata})
  end,
  nil
)

:telemetry.attach_many(
  "my-multi-handler",
  [
    [:my_app, :request, :start],
    [:my_app, :request, :stop],
    [:my_app, :request, :exception]
  ],
  &MyHandler.handle/4,
  nil
)

# Detach
:telemetry.detach("my-handler")

# Span helper
:telemetry.span(
  [:my_app, :operation],
  %{},
  fn ->
    result = do_work()
    {result, %{extra: :metadata}}
  end
)
```

### TelemetryMetricsPrometheus

```elixir
# {:telemetry_metrics, "~> 1.0"}
# {:telemetry_poller, "~> 1.0"}

defmodule MyApp.Telemetry do
  import Telemetry.Metrics

  def metrics do
    [
      counter("my_app.request.stop.count"),
      sum("my_app.request.stop.duration", unit: {:native, :millisecond}),
      last_value("vm.memory.total", unit: {:byte, :megabyte}),
      summary("my_app.request.stop.duration",
        unit: {:native, :millisecond},
        tags: [:path, :status]
      )
    ]
  end
end
```

---

## 9. Mix Releases

Deploy sem Erlang/Elixir instalado no servidor.

```bash
# Gerar release
MIX_ENV=prod mix release

# Estrutura gerada
_build/prod/rel/my_app/
  bin/my_app        # script de controle
  lib/              # código compilado
  releases/         # metadata

# Executar
_build/prod/rel/my_app/bin/my_app start
_build/prod/rel/my_app/bin/my_app start_iex
_build/prod/rel/my_app/bin/my_app stop
_build/prod/rel/my_app/bin/my_app restart
_build/prod/rel/my_app/bin/my_app rpc "IO.puts(:hello)"
```

### mix.exs

```elixir
def project do
  [
    releases: [
      my_app: [
        include_executables_for: [:unix],
        applications: [runtime_tools: :permanent],
        steps: [:assemble, :tar]
      ]
    ]
  ]
end
```

### Runtime config

```elixir
# config/runtime.exs — executado em runtime (não compile-time)
import Config

config :my_app, MyApp.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  pool_size: String.to_integer(System.get_env("POOL_SIZE", "10"))

if config_env() == :prod do
  config :my_app, MyAppWeb.Endpoint,
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE")
end
```

---

## 10. Config System

```
config/config.exs         → compilado (todas as envs, sempre)
config/dev.exs            → compilado (só :dev)
config/test.exs           → compilado (só :test)
config/prod.exs           → compilado (só :prod)
config/runtime.exs        → executado em runtime (mix run e releases)
```

```elixir
# config/config.exs
import Config

config :my_app,
  ecto_repos: [MyApp.Repo]

config :my_app, MyApp.Mailer,
  adapter: Swoosh.Adapters.Local

import_config "#{config_env()}.exs"

# Acessar em runtime
Application.get_env(:my_app, MyApp.Repo)
Application.get_env(:my_app, :key, :default)
Application.fetch_env!(:my_app, :key)
```

---

## 11. Observabilidade: :observer, :sys, :dbg

### :observer

```elixir
# No IEx
:observer.start()
# GUI com processos, memória, tabelas ETS, aplicações
```

### :sys — introspecção de GenServers em runtime

```elixir
# Estado atual
:sys.get_state(Counter)

# Trocar estado em runtime (debug/desenvolvimento)
:sys.replace_state(Counter, fn state -> state + 100 end)

# Log de mensagens
:sys.trace(Counter, true)     # ativa log
:sys.trace(Counter, false)    # desativa

# Estatísticas
:sys.statistics(Counter, true)
:sys.statistics(Counter, :get)
:sys.statistics(Counter, false)
```

### :dbg — tracing de funções

```elixir
# Rastrear todas as chamadas a uma função
:dbg.start()
:dbg.tracer()
:dbg.p(:all, :c)                        # todos os processos, calls
:dbg.tp(MyModule, :my_function, :_)    # rastrear função
:dbg.stop()

# Com :recon (recomendado para produção)
# {:recon, "~> 2.5"}
:recon_trace.calls({MyModule, :my_function, :_}, 10)   # 10 chamadas
:recon_trace.clear()
```

### Process Registry inspection

```elixir
Process.registered()                    # lista de nomes registrados
Process.whereis(MyServer)               # pid pelo nome
:erlang.processes()                     # todos os pids vivos
:erlang.process_count()                 # total de processos

# Inspecionar mailbox
Process.info(pid, :messages)            # mensagens pendentes
Process.info(pid, :message_queue_len)
```

---

## 12. Patterns Avançados

### GenStage / Broadway

Para pipelines de dados com back-pressure.

```elixir
# {:broadway, "~> 1.0"}

defmodule MyPipeline do
  use Broadway

  def start_link(_opts) do
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module: {BroadwaySQS.Producer, queue_url: "..."},
        concurrency: 1
      ],
      processors: [default: [concurrency: 10]],
      batchers: [default: [batch_size: 100, batch_timeout: 2_000]]
    )
  end

  def handle_message(_, message, _context) do
    Broadway.Message.update_data(message, &process/1)
  end

  def handle_batch(_, messages, _, _) do
    # persiste batch
    messages
  end
end
```

### Circuit Breaker com Fuse

```elixir
# {:fuse, "~> 2.4"}
:fuse.install(:my_service, {{:standard, 3, 10_000}, {:reset, 30_000}})

case :fuse.ask(:my_service, :sync) do
  :ok       -> call_service()
  :blown    -> {:error, :circuit_open}
end

:fuse.melt(:my_service)    # reportar falha manualmente
```

### Process pooling com Poolboy / NimblePool

```elixir
# {:nimble_pool, "~> 1.0"}
defmodule DBPool do
  use NimblePool

  def init_pool(opts), do: {:ok, opts}
  def init_worker(pool_state) do
    conn = DBDriver.connect(pool_state)
    {:ok, conn, pool_state}
  end

  def handle_checkout(:checkout, _from, conn, pool_state) do
    {:ok, conn, conn, pool_state}
  end

  def handle_checkin(conn, _from, _old_conn, pool_state) do
    {:ok, conn, pool_state}
  end
end
```
