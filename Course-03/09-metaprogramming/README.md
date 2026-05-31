# 09 - Metaprogramming

Metaprogramação em Elixir é a capacidade de escrever código que gera ou transforma código. O Elixir expõe sua própria AST (Abstract Syntax Tree) como estruturas de dados Elixir, tornando macros de primeira classe na linguagem.

## AST — Abstract Syntax Tree

Todo código Elixir pode ser representado como uma tupla `{função, metadados, argumentos}`:

```elixir
# quote transforma código em AST
quote do: 1 + 2
# {:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]], [1, 2]}

quote do: if true, do: "sim"
# {:if, [...], [true, [do: "sim"]]}
```

### `quote` e `unquote`

```elixir
# quote: captura código como AST sem executar
ast = quote do: IO.puts("hello")

# unquote: injeta um valor dentro de um bloco quote
x = 42
ast = quote do: IO.puts(unquote(x))
# equivale a: quote do: IO.puts(42)
```

## Macros

Macros são funções que recebem AST e retornam AST. São expandidas em tempo de compilação.

```elixir
defmodule MyMacros do
  defmacro unless(condition, do: block) do
    quote do
      if !unquote(condition), do: unquote(block)
    end
  end
end

# Uso:
import MyMacros
unless false, do: IO.puts("executou")
```

> **Regra de ouro:** use funções quando possível. Prefira macros apenas quando precisar manipular código em tempo de compilação.

### `defmacro` vs `def`

| | `def` | `defmacro` |
|--|-------|------------|
| Executado | Em tempo de execução | Em tempo de compilação |
| Recebe | Valores | AST (`quoted expressions`) |
| Retorna | Qualquer valor | AST que será inserida no código |

## `use` e `__using__`

`use ModuleName` chama `ModuleName.__using__/1` no módulo que usa. É o mecanismo por trás de `use GenServer`, `use ExUnit.Case`, etc.

```elixir
defmodule Greeter do
  defmacro __using__(_opts) do
    quote do
      def hello(name), do: "Hello, #{name}!"
      def goodbye(name), do: "Goodbye, #{name}!"
    end
  end
end

defmodule MyModule do
  use Greeter
  # MyModule.hello/1 e MyModule.goodbye/1 ficam disponíveis
end
```

## Module attributes como metadados

Atributos de módulo (ex.: `@doc`, `@spec`, `@behaviour`) são coletados em tempo de compilação e podem ser lidos por macros:

```elixir
defmodule MyModule do
  @my_attr "valor"

  defmacro show_attr do
    attr = Module.get_attribute(__CALLER__.module, :my_attr)
    quote do: IO.puts(unquote(attr))
  end
end
```

## `Macro.expand` e `__ENV__`

```elixir
# Inspecionar como uma macro é expandida
ast = quote do: unless false, do: :ok
Macro.expand(ast, __ENV__)
```

## `__before_compile__` e hooks de compilação

```elixir
defmodule MyLibrary do
  defmacro __using__(_) do
    quote do
      @before_compile MyLibrary
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def summary, do: "módulo compilado com MyLibrary"
    end
  end
end
```

## Boas práticas

- Prefira funções e `use` a macros cruas sempre que possível
- Macros tornam o código mais difícil de debugar e entender
- Use `Macro.expand/2` e `IO.inspect(quote do: ...)` para depurar
- Documente o que a macro injeta no módulo chamador
