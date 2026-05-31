# require, import e use

# require  → habilita macros de um módulo
# import   → traz funções/macros para o namespace local (sem prefixo)
# use      → injeta código no módulo via __using__/1


# --- require ---

defmodule RequireDemo do
  require Integer

  def run do
    IO.puts(Integer.is_odd(3))    # true  — is_odd/1 é macro
    IO.puts(Integer.is_even(4))   # true
    IO.puts(Integer.is_odd(8))    # false
  end
end

IO.puts("--- require ---")
RequireDemo.run()


# --- import ---

defmodule ImportDemo do
  require Integer
  import List, only: [flatten: 1, first: 1]
  import Enum, only: [filter: 2, map: 2]

  def run do
    [1, [2, [3, 4]]]
    |> flatten()
    |> IO.inspect()             # [1, 2, 3, 4]

    [10, 20, 30] |> first() |> IO.inspect()   # 10

    filter([1, 2, 3, 4, 5], &Integer.is_odd/1)
    |> map(&(&1 * 10))
    |> IO.inspect()             # [10, 30, 50]
  end
end

IO.puts("--- import ---")
ImportDemo.run()


# --- use ---
#
# use ModuleName  equivale a:
#   require ModuleName
#   ModuleName.__using__([])
#
# O módulo alvo define __using__/1 como macro, que injeta código
# no módulo que usa. É o mecanismo por trás de GenServer, ExUnit.Case, etc.

defmodule Loggable do
  defmacro __using__(opts) do
    prefix = Keyword.get(opts, :prefix, "[LOG]")

    quote do
      def log(msg),  do: IO.puts("#{unquote(prefix)} #{msg}")
      def warn(msg), do: IO.puts("#{unquote(prefix)} ⚠  #{msg}")
      def info,      do: IO.puts("#{unquote(prefix)} módulo: #{__MODULE__}")
    end
  end
end

defmodule OrderService do
  use Loggable, prefix: "[ORDER]"

  def create(item) do
    log("Criando pedido para: #{item}")
    warn("Estoque baixo!")
  end
end

defmodule PaymentService do
  use Loggable, prefix: "[PAYMENT]"

  def charge(amount), do: log("Cobrando R$ #{amount}")
end

IO.puts("--- use ---")
OrderService.create("notebook")
OrderService.info()
PaymentService.charge(299.90)
PaymentService.info()
