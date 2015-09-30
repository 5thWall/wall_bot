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

  def start_link do
    GenServer.start_link(__MODULE__, @initial_items)
  end

  def add(bucket, obj) do
    GenServer.call(bucket, {:add, obj})
  end

  def handle_call({:add, obj}, _from, items) do
    n = @max - length(items)
    {new_item, items} = case :rand.uniform(n) do
      1 -> replace_at_rnd(items, obj)
      _ -> {:nothing, [obj|items]}
    end

    {:reply, new_item, items}
  end

  defp replace_at_rnd(items, item) do
    n =
      items
      |> length
      |> :rand.uniform
      |> -(1)

    {:ok, new_item} = Enum.fetch(items, n)

    {new_item, List.replace_at(items, n, item)}
  end
end
