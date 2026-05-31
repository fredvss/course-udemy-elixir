# quote e unquote — trabalhando com a AST do Elixir
#
# quote captura código como estrutura de dados (AST) sem executar.
# unquote injeta um valor externo dentro de um bloco quote.

IO.puts("--- Estrutura da AST ---")

IO.inspect(quote do: 1 + 2)                              # {:+, [...], [1, 2]}
IO.inspect(quote do: String.upcase("hello"))
IO.inspect(quote do: (if true, do: "sim", else: "não"))
IO.inspect(quote do: x)                                  # {:x, [], Elixir}

# Literais retornam a si mesmos:
IO.inspect(quote do: 42)          # 42
IO.inspect(quote do: :ok)         # :ok
IO.inspect(quote do: "texto")     # "texto"
IO.inspect(quote do: [1, 2, 3])   # [1, 2, 3]
IO.inspect(quote do: {1, 2})      # {1, 2}


IO.puts("\n--- unquote: injetando valores ---")

x = 10

# COM unquote: o valor de x é inserido na AST
ast_com = quote do: unquote(x) * 3
IO.inspect(ast_com)   # {:*, [...], [10, 3]}

# SEM unquote: x vira variável na AST
ast_sem = quote do: x * 3
IO.inspect(ast_sem)   # {:*, [...], [{:x, [], Elixir}, 3]}
# (x na AST é uma referência a variável, não um valor)

{result_com, _} = Code.eval_quoted(ast_com)
IO.puts("com unquote: #{result_com}")    # 30


IO.puts("\n--- unquote_splicing ---")

args = [1, 2, 3]

ast1 = quote do: Enum.sum(unquote(args))
IO.inspect(ast1)   # {..., [], [[1, 2, 3]]}

ast2 = quote do: [unquote_splicing(args)]
IO.inspect(ast2)   # [1, 2, 3]


IO.puts("\n--- Code.eval_quoted ---")

ast = quote do: Enum.sum([1, 2, 3, 4, 5])
{result, _bindings} = Code.eval_quoted(ast)
IO.puts("Resultado: #{result}")   # 15

n = 10
ast = quote do: unquote(n) * unquote(n)
{result, _} = Code.eval_quoted(ast)
IO.puts("#{n} * #{n} = #{result}")   # 100


IO.puts("\n--- Macro.to_string ---")

ast = quote do
  Enum.map([1, 2, 3], fn x -> x * 2 end)
end
Macro.to_string(ast) |> IO.puts()

ast = quote do
  if x > 0 do
    IO.puts("positivo")
  else
    IO.puts("negativo")
  end
end
Macro.to_string(ast) |> IO.puts()


IO.puts("\n--- Macro.escape ---")

mapa = %{nome: "Fred", linguagem: "Elixir"}

ast = quote do: IO.inspect(unquote(Macro.escape(mapa)))
{_result, _} = Code.eval_quoted(ast)
