# defmacro — escrevendo suas próprias macros
#
# Macros recebem AST e retornam AST.
# São expandidas em tempo de compilação — o código retornado
# é inserido no lugar da chamada antes de o programa rodar.
#
# Em scripts .exs, require de um módulo local precisa acontecer
# dentro de outro módulo (não no nível top-level).


# --- Passo 1: macro mais simples possível ---
#
# defmacro é como def, mas o corpo usa quote para retornar AST.

defmodule M1 do
  defmacro say_hello do
    quote do
      IO.puts("hello from macro!")
    end
  end
end

defmodule Demo1 do
  require M1
  def run, do: M1.say_hello()
end

IO.puts("--- Passo 1: macro mais simples possível ---")
Demo1.run()


# --- Passo 2: macro com argumento e unquote ---
#
# O argumento chega como AST. unquote injeta seu valor no quote.

defmodule M2 do
  defmacro greet(name) do
    quote do
      IO.puts("Olá, #{unquote(name)}!")
    end
  end
end

defmodule Demo2 do
  require M2

  def run do
    M2.greet("Fred")
    M2.greet("Elixir")
  end
end

IO.puts("--- Passo 2: macro com argumento e unquote ---")
Demo2.run()


# --- Passo 3: a diferença fundamental entre macro e função ---
#
# Função: recebe o VALOR de "1 + 2" → 3
# Macro:  recebe a AST  de "1 + 2" → {:+, [], [1, 2]}
#
# IO.inspect(expr) aqui roda em compilação, não em runtime.


IO.puts("--- Passo 3: diferença entre macro e função ---")

defmodule M3 do
  defmacro show_ast(expr) do
    IO.inspect(expr, label: "AST em compilação")
    expr
  end
end

defmodule Demo3 do
  require M3

  def run do
    _ = M3.show_ast(1 + 2)
    _ = M3.show_ast(String.upcase("hello"))
  end
end

Demo3.run()


# --- Passo 4: dbg — mostrando expressão e resultado ---
#
# Macro.to_string/1 converte a AST de volta para string legível.
# Isso só é possível em macro — uma função receberia só o resultado final.

defmodule Dbg do
  defmacro inspect(expr) do
    source = Macro.to_string(expr)

    quote do
      result = unquote(expr)
      IO.puts("#{unquote(source)} => #{Kernel.inspect(result)}")
      result
    end
  end
end

defmodule Demo4 do
  require Dbg

  def run do
    Dbg.inspect(1 + 1)
    Dbg.inspect(String.length("metaprogramming"))
    Dbg.inspect(Enum.filter([1, 2, 3, 4, 5], fn x -> rem(x, 2) != 0 end))
  end
end

IO.puts("--- Passo 4: dbg — expressão e resultado ---")
Demo4.run()


# --- Passo 5: macro com bloco do: ---
#
# Macros podem capturar blocos inteiros de código como AST.
# Uma função não consegue — ela receberia o resultado já calculado.

defmodule Timed do
  defmacro run(do: block) do
    quote do
      t      = System.monotonic_time(:millisecond)
      result = unquote(block)
      IO.puts("#{System.monotonic_time(:millisecond) - t}ms")
      result
    end
  end
end

defmodule Demo5 do
  require Timed

  def run do
    Timed.run do
      Enum.sum(1..1_000_000)
    end

    Timed.run do
      Enum.sort(Enum.shuffle(1..50_000))
    end
  end
end

IO.puts("--- Passo 5: macro com bloco do: ---")
Demo5.run()


# --- Passo 6: geração de funções em tempo de compilação ---
#
# O for roda em compilação e gera uma cláusula de função por iteração.
# É o mesmo que escrever cada função manualmente — mas sem repetição.

IO.puts("--- Passo 6: geração de funções em tempo de compilação ---")

defmodule Validators do
  for type <- [:string, :integer, :float, :boolean] do
    def unquote(:"is_#{type}?")(value) do
      case unquote(type) do
        :string  -> is_binary(value)
        :integer -> is_integer(value)
        :float   -> is_float(value)
        :boolean -> is_boolean(value)
      end
    end
  end
end

IO.puts(Validators.is_string?("hello"))   # true
IO.puts(Validators.is_integer?(42))       # true
IO.puts(Validators.is_float?(3.14))       # true
IO.puts(Validators.is_boolean?(:nope))    # false
