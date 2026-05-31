# 08 - Distribution, Tasks and Agents

Distribuição, execução concorrente de tarefas e gerenciamento simplificado de estado com `Agent`.

## Task

`Task` é uma abstração sobre processos para executar trabalho concorrente e recuperar o resultado de forma simples.

```elixir
# Executar e aguardar o resultado
task = Task.async(fn -> :timer.sleep(500); 42 end)
result = Task.await(task)   # 42

# Timeout personalizado (padrão: 5000 ms)
Task.await(task, 10_000)
```

### Task.async_stream

Processa uma coleção em paralelo com controle de concorrência:

```elixir
["file1.txt", "file2.txt", "file3.txt"]
|> Task.async_stream(&File.read!/1, max_concurrency: 4, timeout: 5000)
|> Enum.map(fn {:ok, content} -> content end)
```

### `Task.start` vs `Task.async`

| Função | Retorna | Resultado recuperável? | Uso típico |
|--------|---------|------------------------|------------|
| `Task.async/1` | `%Task{}` | Sim (via `Task.await`) | Computações paralelas com resultado |
| `Task.start/1` | `{:ok, pid}` | Não | Side effects sem resultado |

### Supervisão de Tasks

Tasks podem ser iniciadas sob um `Task.Supervisor` para isolar falhas:

```elixir
# application.ex
children = [Task.Supervisor.child_spec(name: MyApp.TaskSupervisor)]

# em qualquer lugar
Task.Supervisor.async(MyApp.TaskSupervisor, fn -> do_work() end)
```

## Agent

`Agent` é um GenServer simplificado para gerenciar estado. Útil quando a lógica de negócio está no cliente e o processo só precisa guardar um valor.

```elixir
# Iniciar
{:ok, agent} = Agent.start_link(fn -> 0 end, name: :counter)

# Ler estado
Agent.get(:counter, fn state -> state end)   # 0

# Atualizar estado
Agent.update(:counter, fn state -> state + 1 end)

# Ler e atualizar atomicamente
Agent.get_and_update(:counter, fn state -> {state, state + 1} end)

# Parar
Agent.stop(:counter)
```

### Agent vs GenServer

| | `Agent` | `GenServer` |
|--|---------|-------------|
| Complexidade | Simples | Completo |
| Lógica de negócio | No cliente | No servidor |
| Callbacks | Não | Sim (`handle_call`, `handle_cast`, etc.) |
| Uso ideal | Estado compartilhado simples | Processos com comportamento próprio |

## Distribuição

Elixir roda sobre a BEAM, que suporta clusters de nós Erlang nativamente. Processos em nós diferentes se comunicam da mesma forma que processos locais.

### Iniciando nós

```bash
# Terminal 1
iex --sname node1 --cookie secret

# Terminal 2
iex --sname node2 --cookie secret
```

### Conectando nós

```elixir
# No node1:
Node.connect(:"node2@hostname")

Node.list()            # [:"node2@hostname"]
Node.self()            # :"node1@hostname"
```

### Chamadas remotas

```elixir
# Executar função em outro nó
Node.spawn(:"node2@hostname", fn -> IO.puts("rodando em node2") end)

# Ou com Task
Task.Supervisor.async({MyApp.TaskSupervisor, :"node2@hostname"}, fn -> do_work() end)
```

### Considerações

- Todos os nós devem compartilhar o mesmo **cookie** (`--cookie`) para se conectar
- Nomes curtos (`--sname`) funcionam na mesma máquina; nomes completos (`--name`) para redes diferentes
- A distribuição usa TCP: firewall pode bloquear as portas EPMD (4369) e as portas de nó
