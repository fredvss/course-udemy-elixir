defmodule ExMon.Player do

  # variavel de modulo
  @required_keys [:life, :name, :moves]
  @max_life 100

  # força campos obrigatorios
  @enforce_keys @required_keys
  # define a estrutura de uma struct - um map com um nome
  defstruct @required_keys

  def build(name, move_rnd, move_avg, move_heal) do
    %ExMon.Player{
      name: name,
      life: @max_life,
      moves: %{
        move_rnd: move_rnd,
        move_avg: move_avg,
        move_heal: move_heal
      }
    }
  end
end
