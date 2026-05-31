defmodule GameOfStonesTest do
  use ExUnit.Case

  describe "GameOfStones.Server" do
    setup do
      # Para cada teste, garante que o servidor não está rodando
      case Process.whereis(GameOfStones.Server) do
        nil -> :ok
        pid -> GenServer.stop(pid)
      end

      :ok
    end

    test "start/1 inicia o servidor com o número de pedras informado" do
      {:ok, _pid} = GameOfStones.Server.start(10)
      assert GameOfStones.Server.stats() == {1, 10}
    end

    test "take/1 retorna {:next_turn, proximo_jogador, pedras_restantes}" do
      GameOfStones.Server.start(10)
      assert GameOfStones.Server.take(3) == {:next_turn, 2, 7}
    end

    test "take/1 retorna {:error, _} para jogada fora do intervalo 1-3" do
      GameOfStones.Server.start(10)
      assert {:error, _} = GameOfStones.Server.take(4)
      assert {:error, _} = GameOfStones.Server.take(0)
    end

    test "take/1 retorna {:error, _} quando há menos pedras do que o solicitado" do
      GameOfStones.Server.start(2)
      assert {:error, _} = GameOfStones.Server.take(3)
    end

    test "take/1 retorna {:winner, jogador} quando a última pedra é removida" do
      GameOfStones.Server.start(2)
      GameOfStones.Server.take(1)
      assert GameOfStones.Server.take(1) == {:winner, 1}
    end

    test "alternância de turno entre jogador 1 e 2" do
      GameOfStones.Server.start(10)
      assert {1, 10} = GameOfStones.Server.stats()
      GameOfStones.Server.take(1)
      assert {2, 9} = GameOfStones.Server.stats()
      GameOfStones.Server.take(1)
      assert {1, 8} = GameOfStones.Server.stats()
    end
  end
end
