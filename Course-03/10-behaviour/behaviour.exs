# @behaviour — contratos entre módulos
#
# @behaviour define um conjunto de @callback que um módulo DEVE implementar.
# O compilador verifica em compilação e emite warnings se faltar algum.
#
# Diferença do Protocol:
#   Behaviour → "qual MÓDULO implementa esta interface?" (escolha explícita)
#   Protocol  → "como este TIPO se comporta aqui?"      (despacho por tipo)


# --- Definindo um Behaviour ---

defmodule Notifier do
  @callback send(recipient :: String.t(), message :: String.t()) ::
              {:ok, String.t()} | {:error, String.t()}

  @callback healthy?() :: boolean()

  @callback channel_name() :: String.t()

  @optional_callbacks [schedule: 3]
  @callback schedule(recipient :: String.t(), message :: String.t(), at :: DateTime.t()) ::
              {:ok, String.t()} | {:error, String.t()}
end


# --- Implementações ---

defmodule EmailNotifier do
  @behaviour Notifier

  @impl Notifier
  def send(recipient, message) do
    IO.puts("[Email] Enviando para #{recipient}: #{message}")
    {:ok, "email_#{:rand.uniform(9999)}"}
  end

  @impl Notifier
  def healthy?, do: true

  @impl Notifier
  def channel_name, do: "Email"

  @impl Notifier
  def schedule(recipient, message, at) do
    IO.puts("[Email] Agendado para #{recipient} em #{DateTime.to_string(at)}: #{message}")
    {:ok, "email_scheduled_#{:rand.uniform(9999)}"}
  end
end

defmodule SmsNotifier do
  @behaviour Notifier

  @impl Notifier
  def send(recipient, message) do
    if String.length(message) > 160 do
      {:error, "SMS limitado a 160 caracteres"}
    else
      IO.puts("[SMS] Enviando para #{recipient}: #{message}")
      {:ok, "sms_#{:rand.uniform(9999)}"}
    end
  end

  @impl Notifier
  def healthy?, do: true

  @impl Notifier
  def channel_name, do: "SMS"

  # schedule/3 não implementado — é @optional_callbacks, sem warning
end

defmodule SlackNotifier do
  @behaviour Notifier

  @impl Notifier
  def send(recipient, message) do
    IO.puts("[Slack] Postando em ##{recipient}: #{message}")
    {:ok, "slack_msg_#{:rand.uniform(9999)}"}
  end

  @impl Notifier
  def healthy?, do: false   # simulado como fora do ar

  @impl Notifier
  def channel_name, do: "Slack"
end


# --- Polimorfismo via Behaviour ---
#
# O cliente recebe o módulo como parâmetro — não sabe qual implementação está usando.

defmodule NotificationService do
  def notify(notifier, recipient, message) do
    if notifier.healthy?() do
      case notifier.send(recipient, message) do
        {:ok, id}       -> IO.puts("  ✓ [#{notifier.channel_name()}] ID: #{id}")
        {:error, reason} -> IO.puts("  ✗ [#{notifier.channel_name()}] #{reason}")
      end
    else
      IO.puts("  ✗ [#{notifier.channel_name()}] Canal indisponível")
    end
  end

  def broadcast(notifiers, recipient, message) do
    Enum.each(notifiers, &notify(&1, recipient, message))
  end
end

IO.puts("--- Notificações ---")
NotificationService.notify(EmailNotifier, "fred@example.com", "Bem-vindo!")
NotificationService.notify(SmsNotifier, "+5511999999999", "Código: 1234")
NotificationService.notify(SlackNotifier, "alerts", "Deploy concluído")

IO.puts("\n--- Broadcast ---")
NotificationService.broadcast(
  [EmailNotifier, SmsNotifier, SlackNotifier],
  "fred",
  "Sistema atualizado"
)


# --- GenServer é um Behaviour ---
#
# use GenServer injeta @behaviour GenServer + implementações padrão.
# Você sobrescreve apenas os callbacks que precisa.

defmodule Counter do
  use GenServer

  @impl GenServer
  def init(initial), do: {:ok, initial}

  @impl GenServer
  def handle_call(:get, _from, state),       do: {:reply, state, state}
  def handle_call(:increment, _from, state), do: {:reply, state + 1, state + 1}

  @impl GenServer
  def handle_cast(:reset, _state), do: {:noreply, 0}

  def start_link(initial \\ 0), do: GenServer.start_link(__MODULE__, initial)
  def get(pid),                  do: GenServer.call(pid, :get)
  def increment(pid),            do: GenServer.call(pid, :increment)
  def reset(pid),                do: GenServer.cast(pid, :reset)
end

IO.puts("\n--- Counter (GenServer) ---")
{:ok, pid} = Counter.start_link(0)
IO.puts("Inicial: #{Counter.get(pid)}")
IO.puts("Após ++: #{Counter.increment(pid)}")
IO.puts("Após ++: #{Counter.increment(pid)}")
Counter.reset(pid)
:timer.sleep(10)
IO.puts("Após reset: #{Counter.get(pid)}")
