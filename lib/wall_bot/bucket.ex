defmodule WallBot.Bucket do
  @moduledoc """
  """

  @max 20
  @initial_items [
    "the D.I.C. codebase",
    "five dosen eggs",
    "omelette du fromage",
    "four tons of glitter",
    "root permissions",
    "a traffic cone",
    "death",
    "a fine red mist",
    "the Fall `04 Toonami lineup",
    "a pretty pink princess pony",
    "science!"
  ]

  use GenServer

  ##
  # Client Implementation

  def start_link(initial_items \\ @initial_items, max \\ @max) do
    GenServer.start_link(__MODULE__, %{items: initial_items, max: max})
  end

  def add(bucket, obj) do
    GenServer.call(bucket, {:add, obj})
  end

  def take(bucket) do
    GenServer.call(bucket, :take)
  end

  ##
  # Server Implementation

  def handle_call({:add, obj}, _from, state = %{items: []}) do
    {:reply, :nothing, %{state | items: [obj]}}
  end

  def handle_call({:add, obj}, _from, state = %{items: items}) do
    n = state.max - length(items)
    {new_item, items} = case :rand.uniform(n) do
      1 -> replace_at_rnd(items, obj)
      _ -> {:nothing, [obj|items]}
    end

    {:reply, new_item, %{state | items: items}}
  end

  def handle_call(:take, _from, state = %{items: []}) do
    {:reply, :nothing, state}
  end

  def handle_call(:take, _from, state = %{items: items}) do
    {new_item, items} = take_rnd(items)

    {:reply, new_item, %{state | items: items}}
  end

  defp replace_at_rnd(items, item) do
    n = rand_index(items)

    {:ok, new_item} = Enum.fetch(items, n)

    {new_item, List.replace_at(items, n, item)}
  end

  defp take_rnd(items) do
    n = rand_index(items)

    {:ok, item} = Enum.fetch(items, n)

    {item, List.delete_at(items, n)}
  end

  defp rand_index(list) do
    list
    |> length
    |> :rand.uniform
    |> -(1)
  end
end
