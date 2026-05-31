# defprotocol — polimorfismo baseado em tipo de dado
#
# Um Protocol define uma interface (conjunto de funções).
# Cada tipo pode ter sua própria implementação via defimpl.
# O despacho é automático em runtime com base no tipo do primeiro argumento.


# --- Definindo um Protocol ---

defprotocol Describable do
  def describe(value)
end


# --- Implementações para tipos built-in ---

defimpl Describable, for: Integer do
  def describe(n), do: "inteiro: #{n}"
end

defimpl Describable, for: Float do
  def describe(f), do: "float: #{Float.round(f, 4)}"
end

defimpl Describable, for: BitString do
  def describe(s), do: "string(#{String.length(s)}): \"#{s}\""
end

defimpl Describable, for: Map do
  def describe(m), do: "map com chaves: #{inspect(Map.keys(m))}"
end


# --- Despacho automático ---

IO.puts("--- tipos built-in ---")
IO.puts(Describable.describe(42))
IO.puts(Describable.describe(3.14159))
IO.puts(Describable.describe("Elixir"))
IO.puts(Describable.describe(%{a: 1, b: 2}))


# --- Protocol com struct (tipo customizado) ---

IO.puts("--- struct customizado ---")

defmodule Product do
  defstruct [:name, :price]
end

defimpl Describable, for: Product do
  def describe(%Product{name: n, price: p}), do: "produto: #{n} por R$ #{p}"
end

defmodule ProductDemo do
  def run do
    IO.puts(Describable.describe(%Product{name: "Notebook", price: 4599.90}))

    IO.puts("\n--- Protocol.impl_for ---")
    IO.inspect(Describable.impl_for(42))
    IO.inspect(Describable.impl_for("texto"))
    IO.inspect(Describable.impl_for(%Product{}))
    IO.inspect(Describable.impl_for(:atom))   # nil — não implementado
  end
end

ProductDemo.run()


# --- @fallback_to_any — implementação padrão para tipos não cobertos ---

defprotocol Printable do
  @fallback_to_any true
  def print(value)
end

defimpl Printable, for: Any do
  def print(value), do: IO.puts("[Any] #{inspect(value)}")
end

defimpl Printable, for: BitString do
  def print(s), do: IO.puts("[String] #{s}")
end

IO.puts("--- @fallback_to_any ---")
Printable.print("olá")        # usa impl for BitString
Printable.print(:ok)          # usa impl for Any (fallback)
Printable.print([1, 2, 3])    # usa impl for Any (fallback)
