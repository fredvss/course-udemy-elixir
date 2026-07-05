# Mix Tasks — Tarefas customizadas

Demonstra como criar **tarefas Mix** (`mix nome_da_tarefa`) para automatizar scripts locais, seguindo a convenção `lib/mix/tasks/`.

## Conceitos

- `use Mix.Task` e `@shortdoc`
- Implementação de `run/1` com argumentos da linha de comando
- `Mix.shell().info/1` e `Mix.shell().error/1`
- `OptionParser` para flags (`--upper`)
- Separação entre tarefa (CLI) e lógica reutilizável (`MixTasks.Greeter`)

## Tarefas disponíveis

| Comando | Descrição |
|---------|-----------|
| `mix hello` | Imprime uma saudação simples |
| `mix greet NOME` | Sauda um nome |
| `mix greet --upper NOME` | Sauda em maiúsculas |
| `mix stats 10 20 30` | Soma, média e máximo de números |

## Como usar

```bash
cd Basics/mix_tasks

mix hello
mix greet Phoenix
mix greet --upper elixir
mix stats 10 20 30 5

mix test
```

## Estrutura

```text
mix_tasks/
├── lib/
│   ├── mix/tasks/
│   │   ├── hello.ex       # mix hello
│   │   ├── greet.ex       # mix greet
│   │   └── stats.ex       # mix stats
│   └── mix_tasks/
│       ├── application.ex
│       └── greeter.ex     # lógica compartilhada
└── test/
```

## Convenção de nomes

O arquivo `lib/mix/tasks/greet.ex` define `Mix.Tasks.Greet`, invocável com `mix greet`. Para subcomandos aninhados, use `lib/mix/tasks/app.seed.ex` → `mix app.seed`.

## Testes

```bash
mix test
```

## Próximos passos

- [phoenix_hello](../phoenix_hello/) — primeiro app web com Phoenix
- [Course-03/06-mix-tool](../../Course-03/06-mix-tool/) — Mix em profundidade
