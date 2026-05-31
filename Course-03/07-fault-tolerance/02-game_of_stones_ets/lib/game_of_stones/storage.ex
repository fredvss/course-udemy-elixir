defmodule GameOfStones.Storage do
  use GenServer, restart: :transient

  @server_name :storage
  @ets_name :game_of_stones_storage

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: @server_name)
  end

  def init(_args) do
    :ets.new(@ets_name, [:ordered_set, :private, :named_table, {:keypos, 2}])
    {:ok, nil}
  end

  def store(data) do
    IO.inspect(data, label: "Storing the data")
    GenServer.call(@server_name, {:store, data})
  end

  def fetch() do
    GenServer.call(@server_name, :fetch)
  end

  def fetch_all() do
    GenServer.call(@server_name, :fetch_all)
  end

  def handle_call({:store, {:winner, _}}, _from, state) do
    IO.puts("Deleting stored data ...")
    :ets.delete_all_objects(@ets_name)
    {:reply, :ok, state}
  end

  def handle_call({:store, data}, _from, state) do
    :ets.insert(@ets_name, data)
    {:reply, :ok, state}
  end

  def handle_call(:fetch_all, _from, state) do
    data = :ets.tab2list(@ets_name)
    {:reply, data, state}
  end

  def handle_call(:fetch, _from, state) do
    # :ordered_set ordena por chave (num_stones) de forma ascendente;
    # o menor num_stones é o estado mais recente (última jogada).
    result =
      case :ets.tab2list(@ets_name) do
        [] -> nil
        list -> hd(list)
      end

    {:reply, result, state}
  end
end
