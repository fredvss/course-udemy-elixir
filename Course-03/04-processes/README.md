# 04 - Processes

Processos são a unidade básica de concorrência em Elixir. São leves, isolados (sem memória compartilhada) e se comunicam exclusivamente por troca de mensagens. Toda a OTP é construída sobre esse modelo.

## Conceitos fundamentais

### Spawn

Cria um novo processo que executa uma função. O processo pai não espera o filho terminar.

```elixir
pid = spawn(fn -> IO.puts("rodando em outro processo") end)
Process.alive?(pid)  # false (provavelmente já terminou)
```

### Troca de mensagens

Processos se comunicam via `send/2` e `receive/1`. A mailbox guarda mensagens até serem consumidas.

```elixir
# Enviar mensagem para si mesmo
send(self(), {:ola, "mundo"})

# Receber
receive do
  {:ola, msg} -> IO.puts(msg)
after 5000    -> IO.puts("timeout")
end
```

### Links (`spawn_link`)

Processos linkados propagam falhas entre si: se um morrer com erro, o outro também morre.

```elixir
spawn_link(fn -> raise "boom" end)
# processo pai também morre, a menos que esteja trapeando exits
```

### Monitors (`spawn_monitor` / `Process.monitor`)

Monitors permitem **observar** um processo sem ser afetado pela sua morte. O observador recebe uma mensagem `{:DOWN, ref, :process, pid, reason}`.

```elixir
{pid, ref} = spawn_monitor(fn -> exit(:error) end)

receive do
  {:DOWN, ^ref, :process, _pid, reason} ->
    IO.puts("Processo morreu: #{inspect(reason)}")
end
```

### Diferença entre Link e Monitor

| | Link | Monitor |
|---|------|--------|
| Efeito na morte | Bidirecional (mata o par) | Unidirecional (só notifica) |
| Mensagem recebida | Sinal de exit | `{:DOWN, ref, ...}` |
| Uso típico | Supervisor/filho | Observar processos externos |

## Funções úteis

```elixir
self()                          # PID do processo atual
spawn(fun)                      # cria processo
spawn_link(fun)                 # cria processo linkado
spawn_monitor(fun)              # cria processo monitorado
send(pid, message)              # envia mensagem
Process.alive?(pid)             # verifica se está vivo
Process.exit(pid, :kill)        # mata um processo
Process.register(pid, :nome)    # registra PID com nome
Process.whereis(:nome)          # busca PID pelo nome
```

## Subpastas

| Pasta | Conteúdo |
|-------|----------|
| `spawning-processes` | Spawn de múltiplos processos concorrentes |
| `message-passing` | Comunicação entre processos: envio simples e coleta de respostas |
| `links-and-monitors` | Tratamento de falhas com `spawn_link` e `spawn_monitor` |
| `game-of-stones-server` | Servidor de estado para o jogo usando processos puros |
| `game-of-stones-complete` | Versão completa do jogo com cliente e servidor |

## Comandos úteis

```bash
# Rodar qualquer arquivo de exemplo
elixir processes.exs

# Explorar no IEx
iex> pid = spawn(fn -> :timer.sleep(10_000) end)
iex> Process.alive?(pid)
iex> Process.info(pid)
iex> Process.list() |> length()   # total de processos rodando
```
