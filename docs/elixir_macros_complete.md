# Elixir Metaprogramming — Macros, use, require, import

## 1. Mental Model: Código como Dados

Elixir compila em 2 fases:
1. **Expansão de macros** — transforma a AST (Abstract Syntax Tree)
2. **Compilação** — gera bytecode BEAM

Macros operam na fase 1: recebem AST e retornam AST.

```
Código fonte
    ↓  parse
   AST
    ↓  expand macros
 AST expandida
    ↓  compile
  bytecode BEAM
```

---

## 2. AST (Abstract Syntax Tree)

Toda expressão Elixir tem uma representação como AST.

### quote — capturar AST sem executar

```elixir
quote do
  1 + 2
end
# {:+, [context: Elixir, imports: [{1, Kernel}, {2, Kernel}]], [1, 2]}

quote do
  x = 1 + 2
end
# {:=, [], [{:x, [], Elixir}, {:+, [], [1, 2]}]}

quote do
  if true, do: :yes, else: :no
end
# {:if, [context: Elixir, imports: [{2, Kernel}]],
#  [true, [do: :yes, else: :no]]}
```

### Estrutura da AST

```elixir
# Átomo, número, string → representam a si mesmos
:hello      # :hello
42          # 42
"hi"        # "hi"

# Expressões → tupla de 3 elementos
{operador_ou_nome, metadados, argumentos_ou_contexto}

# Exemplos
{:foo, [], []}           # variável `foo`
{:foo, [], Elixir}       # variável `foo` no contexto Elixir
{:+, [], [1, 2]}         # 1 + 2
{:., [], [IO, :puts]}    # IO.puts (chamada remota)

# Literal: listas, tuplas de 2 são representadas diretamente
[1, 2, 3]            # [1, 2, 3]
{:a, :b}             # {:a, :b}  (tupla de 2 só!)
```

### unquote — injetar valores na AST

```elixir
x = 42
quote do
  x + 1       # x não é resolvido → {:x, [], Elixir}
end

quote do
  unquote(x) + 1   # injeta 42 → {:+, [], [42, 1]}
end

# unquote_splicing — injeta uma lista de elementos
args = [1, 2, 3]
quote do
  sum(unquote_splicing(args))
end
# {:sum, [], [1, 2, 3]}
```

### Inspecionar AST

```elixir
quoted = quote do: 1 + 2 * 3
Macro.to_string(quoted)      # "1 + 2 * 3"  (de volta ao código)

# Ver AST expandida de uma expressão
Macro.expand(quoted, __ENV__)
Macro.expand_once(quoted, __ENV__)
```

---

## 3. import

Traz funções e macros de um módulo para o escopo local, eliminando o prefixo.

### Uso básico

```elixir
import Enum
map([1,2,3], &(&1 * 2))    # sem prefixo Enum.

import String
upcase("hello")             # String.upcase/1 disponível como upcase/1
```

### Opções

```elixir
# Apenas funções específicas
import Enum, only: [map: 2, filter: 2, reduce: 3]

# Apenas macros
import Logger, only: :macros

# Apenas funções
import MyModule, only: :functions

# Excluir funções
import Kernel, except: [inspect: 1]

# warn: false — silencia aviso de "unused import"
import Enum, only: [map: 2], warn: false
```

### Escopo

`import` é lexicamente escopoado. Só vale no bloco onde aparece.

```elixir
def my_func do
  import Enum, only: [map: 2]
  map([1,2,3], &(&1 * 2))   # ok aqui
end

def other_func do
  map([1,2,3], &(&1 * 2))   # erro: map não importada aqui
end
```

### Quando NÃO usar

- Módulos grandes (polui namespace, dificulta descoberta de origem)
- APIs públicas de bibliotecas
- Quando há conflito de nomes

---

## 4. require

Carrega macros de um módulo em tempo de compilação. Necessário porque macros precisam existir **antes** de serem expandidas.

### Por que é necessário

Funções são resolvidas em runtime. Macros são expandidas em compile-time.
Se você chamar uma macro sem `require`, o compilador não sabe que é uma macro e tenta chamar como função.

```elixir
# Sem require → erro de compilação ou chamada errada
Logger.info("msg")         # erro se Logger não carregado

# Com require → correto
require Logger
Logger.info("msg")          # expandido para código de log com level check
```

### Exemplos práticos

```elixir
require Logger
Logger.debug("debug msg")   # macro: elimina código se log level > debug
Logger.info("info msg")
Logger.warning("warn")
Logger.error("error")

require Integer
Integer.is_even(4)           # macro: pode ser usada em guards
Integer.is_odd(3)

require Bitwise
Bitwise.band(0b1010, 0b1100)  # AND bit a bit

# Em guards — só macros podem ser usadas
def check(n) when Integer.is_even(n), do: :even
def check(n) when Integer.is_odd(n),  do: :odd
```

### require vs import

```elixir
require Enum      # carrega macros, mas ainda precisa prefixo: Enum.map(...)
import Enum       # carrega E elimina prefixo: map(...)
# import faz require implicitamente
```

---

## 5. use

Injeção de código em tempo de compilação. O padrão mais poderoso de reutilização.

### Como funciona

```elixir
use Module
# equivale a:
require Module
Module.__using__([])

use Module, option: :value
# equivale a:
require Module
Module.__using__(option: :value)
```

### Implementando `__using__`

```elixir
defmodule Pluggable do
  defmacro __using__(opts) do
    quote do
      @behaviour Pluggable

      # Injeta imports
      import Pluggable.Helpers

      # Injeta atributos
      @pluggable_opts unquote(opts)

      # Injeta implementação padrão
      def default_name, do: __MODULE__ |> to_string() |> String.downcase()

      # Permite que o módulo usando sobrescreva
      defoverridable [default_name: 0]
    end
  end
end

defmodule MyPlug do
  use Pluggable, prefix: "my"

  # sobrescreve o padrão
  def default_name, do: "my_plug"
end
```

### Exemplos do ecossistema

```elixir
use GenServer     # injeta @behaviour, callbacks padrão, child_spec
use Supervisor    # injeta @behaviour, init helpers
use Agent         # mesmo padrão
use Application   # @behaviour Application

use Ecto.Schema   # injeta schema DSL, tipos, associations
use Ecto.Changeset # injeta funções de validação

use Phoenix.Controller  # injeta conn/view helpers, imports
use Phoenix.LiveView    # injeta socket, assigns, render
```

---

## 6. Escrevendo Macros

### defmacro

```elixir
defmodule MyMacros do
  defmacro unless(expr, do: block) do
    quote do
      if !unquote(expr), do: unquote(block)
    end
  end

  defmacro swap(a, b) do
    quote do
      {unquote(a), unquote(b)} = {unquote(b), unquote(a)}
    end
  end

  defmacro debug(expr) do
    quote do
      result = unquote(expr)
      IO.puts("#{unquote(Macro.to_string(expr))} = #{inspect(result)}")
      result
    end
  end
end

# Uso
require MyMacros

MyMacros.unless false do
  IO.puts("executou!")
end

MyMacros.debug(1 + 2 * 3)
# 1 + 2 * 3 = 7
```

### Macro com múltiplas cláusulas

```elixir
defmodule Validator do
  defmacro validate(field, :required) do
    quote do
      if is_nil(unquote(field)) or unquote(field) == "" do
        {:error, "#{unquote(Macro.to_string(field))} is required"}
      else
        :ok
      end
    end
  end

  defmacro validate(field, {:min, n}) do
    quote do
      if String.length(to_string(unquote(field))) < unquote(n) do
        {:error, "#{unquote(Macro.to_string(field))} min #{unquote(n)} chars"}
      else
        :ok
      end
    end
  end
end
```

---

## 7. Higiene de Macros

Macros são **higiênicas** por padrão: variáveis definidas dentro de `quote` não vazam para o escopo chamador.

```elixir
defmacro set_x do
  quote do
    x = 42    # este x é isolado — não polui o escopo externo
  end
end

x = 1
require MyMacros
MyMacros.set_x()
x    # ainda é 1!
```

### var! — quebrar higiene intencionalmente

```elixir
defmacro inject_conn do
  quote do
    var!(conn) = Plug.Conn.new()   # modifica `conn` do escopo chamador
  end
end

# Uso em Phoenix Plugs:
# plug :set_user é higiênico porque usa conn explicitamente
```

### alias! — higiene para aliases

```elixir
defmacro use_my_module do
  quote do
    alias!(MyModule)    # alias respeitando o contexto chamador
  end
end
```

### Contexto explícito

```elixir
quote context: MyModule do
  x = 1   # x fica no contexto de MyModule
end
```

---

## 8. Atributos de Módulo

Atributos são dados associados ao módulo, avaliados em compile-time.

```elixir
defmodule Config do
  @app_name "MyApp"            # constante
  @version Mix.Project.config()[:version]  # calculado em compile-time
  @external_resource "priv/data.json"      # declara dependência de arquivo

  @doc "Retorna o nome da aplicação"
  def name, do: @app_name

  @doc "Retorna a versão"
  def version, do: @version
end
```

### Acumular com @

Atributos podem ser acumulados se acessados múltiplas vezes.

```elixir
defmodule Routes do
  Module.register_attribute(__MODULE__, :routes, accumulate: true)

  @routes {:get, "/users"}
  @routes {:post, "/users"}
  @routes {:get, "/users/:id"}

  def all_routes, do: @routes
  # [get: "/users/:id", post: "/users", get: "/users"]
end
```

### Atributos padrão

```elixir
@moduledoc    # documentação do módulo (String ou false)
@doc          # documentação de função
@spec         # typespec
@type         # definir tipo
@typep        # tipo privado
@opaque       # tipo opaco (sem expor estrutura)
@behaviour    # declarar behaviour a implementar
@impl         # sinaliza implementação de callback (valida no compile)
@vsn          # versão para hot code reload
@on_load      # função chamada ao carregar o módulo
@compile      # opções de compilação
@dialyzer     # hints para Dialyzer
@derive       # derivar protocolos automaticamente
```

---

## 9. Hooks de Compilação

### @on_definition

Chamado para cada função/macro definida no módulo.

```elixir
defmodule Tracker do
  def __on_definition__(env, kind, name, args, guards, body) do
    IO.puts("Definindo #{kind} #{name}/#{length(args)} em #{env.file}:#{env.line}")
  end
end

defmodule MyModule do
  @on_definition Tracker

  def hello, do: :world
  def add(a, b), do: a + b
end
```

### @before_compile

Executado **antes** do módulo ser finalizado. Pode injetar código usando informações acumuladas.

```elixir
defmodule RouteBuilder do
  defmacro __before_compile__(env) do
    routes = Module.get_attribute(env.module, :routes)

    dispatch_clauses = Enum.map(routes, fn {method, path, handler} ->
      quote do
        def dispatch(unquote(method), unquote(path)), do: unquote(handler)
      end
    end)

    quote do
      unquote_splicing(dispatch_clauses)
      def dispatch(_, _), do: {:error, :not_found}
    end
  end
end

defmodule MyRouter do
  @before_compile RouteBuilder

  Module.register_attribute(__MODULE__, :routes, accumulate: true)
  @routes {:get, "/", :index}
  @routes {:get, "/users", :list_users}
  @routes {:post, "/users", :create_user}
end

MyRouter.dispatch(:get, "/")         # :index
MyRouter.dispatch(:get, "/missing")  # {:error, :not_found}
```

### @after_compile

Executado após a compilação. Útil para validações.

```elixir
defmodule Validator do
  defmacro __after_compile__(env, _bytecode) do
    required = Module.get_attribute(env.module, :required_callbacks)
    Enum.each(required, fn cb ->
      unless Module.defines?(env.module, cb) do
        raise CompileError,
          description: "#{env.module} deve implementar #{inspect(cb)}"
      end
    end)
  end
end
```

---

## 10. DSL com Macros

Exemplo completo: mini DSL para definir schemas.

```elixir
defmodule Schema do
  defmacro __using__(_opts) do
    quote do
      import Schema
      Module.register_attribute(__MODULE__, :fields, accumulate: true)
      @before_compile Schema
    end
  end

  defmacro field(name, type, opts \ []) do
    quote do
      @fields {unquote(name), unquote(type), unquote(opts)}
    end
  end

  defmacro __before_compile__(env) do
    fields = Module.get_attribute(env.module, :fields) |> Enum.reverse()

    field_defs = Enum.map(fields, fn {name, _type, opts} ->
      default = Keyword.get(opts, :default)
      quote do: defstruct(unquote([{name, default}]))
    end)

    getters = Enum.map(fields, fn {name, _type, _opts} ->
      quote do
        def unquote(:"get_#{name}")(struct), do: Map.get(struct, unquote(name))
      end
    end)

    fields_list = Enum.map(fields, fn {name, type, opts} ->
      {name, type, opts}
    end)

    quote do
      unquote_splicing(field_defs)

      def __fields__, do: unquote(Macro.escape(fields_list))

      unquote_splicing(getters)
    end
  end
end

# Uso
defmodule User do
  use Schema

  field :name, :string, default: "Anonymous"
  field :age,  :integer, default: 0
  field :email, :string
end

user = %User{name: "Alice", age: 30}
User.__fields__()           # [{:name, :string, [default: "Anonymous"]}, ...]
User.get_name(user)         # "Alice"
```

---

## 11. Macro.escape e Estruturas de Dados

Para injetar valores complexos (maps, listas, structs) em AST use `Macro.escape/1`.

```elixir
config = %{host: "localhost", port: 5432}

quote do
  # Errado: map não é AST válida diretamente
  opts = unquote(config)
end

quote do
  # Correto: escapa o valor para representação AST
  opts = unquote(Macro.escape(config))
end
```

---

## 12. Quando Usar Macros

### Use macros quando:

- Construindo DSLs (Ecto schema, Phoenix router, ExUnit)
- Eliminando boilerplate que depende do AST
- Gerando código em compile-time baseado em dados externos
- Precisar que código seja executado em compile-time
- Otimizações que dependem de valores conhecidos na compilação

### Não use macros quando:

- Uma função resolve o problema (macros são mais difíceis de debugar)
- O valor só é conhecido em runtime
- Apenas organização de código (use módulos e funções)
- Callbacks/behaviours já resolvem o contrato

### Regra prática

> "A macro deve ser a última opção, não a primeira."
> — José Valim

```elixir
# Prefira função
def process(data), do: data |> transform() |> validate()

# Use macro só se precisar operar na AST
defmacro assert_match(pattern, value) do
  quote do
    case unquote(value) do
      unquote(pattern) -> :ok
      other -> raise "Expected #{unquote(Macro.to_string(pattern))}, got: #{inspect(other)}"
    end
  end
end
```

---

## 13. Exemplos Reais do Ecossistema

### Como GenServer usa use

```elixir
# Simplificado do que GenServer.__using__ injeta:
defmacro __using__(opts) do
  quote location: :keep, bind_quoted: [opts: opts] do
    @behaviour GenServer

    def child_spec(init_arg) do
      %{
        id: __MODULE__,
        start: {__MODULE__, :start_link, [init_arg]},
        type: :worker
      }
    end

    defoverridable child_spec: 1

    # Implementações padrão que podem ser sobrescritas
    def handle_call(msg, _from, state) do
      proc = {__MODULE__, self()}
      raise "attempted to call GenServer #{inspect(proc)} but no handle_call/3..."
    end

    defoverridable handle_call: 3
  end
end
```

### Como ExUnit.Case funciona

```elixir
defmacro __using__(opts) do
  quote do
    import ExUnit.Assertions
    import ExUnit.Callbacks
    import ExUnit.Case, only: [describe: 2, test: 1, test: 2, test: 3]

    Module.register_attribute(__MODULE__, :ex_unit_tests, accumulate: true)
    @before_compile ExUnit.Case
  end
end

defmacro test(message, context \ quote(do: _), contents) do
  quote do
    @ex_unit_tests {unquote(message), unquote(context)}
    def unquote(:"test #{message}")(unquote(context)) do
      unquote(contents)
    end
  end
end
```
