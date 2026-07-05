# Dicas para explorar no IEx
# Execute: elixir 04_help_and_info.exs
# No IEx, experimente: h Enum.map/2, i [1,2,3], c "modulo"

IO.puts("""
=== Comandos úteis do IEx ===

  h Enum.map/2     # documentação de uma função
  h Enum           # visão geral de um módulo
  i "hello"        # informações sobre um valor (tipo, tamanho, etc.)
  c "arquivo.ex"   # compilar um arquivo .ex
  recompile()      # recompilar módulos alterados (com iex -S mix)

=== Atalhos ===

  Ctrl+C duas vezes   # sair do IEx
  ↑ / ↓               # histórico de comandos
  Tab                 # autocompletar

=== Experimente agora ===
Abra o IEx e digite:

  iex> h String.split/3
  iex> i %{a: 1, b: 2}
  iex> 1..5 |> Enum.map(&(&1 * 2)) |> IO.inspect()
""")
