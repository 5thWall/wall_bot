defmodule WallBot do
  @moduledoc """
  Main module for wallbot. Handles connecting to channels and setting up plugins
  """

  alias DogIRC.Client

  def main do
    Client.join("#dogirc")
    add_bucket
    add_box_of_hate
  end

  defp add_bucket do
    {:ok, bucket} = WallBot.Bucket.start_link
    Client.add_handler(WallBot.BucketHandler, bucket)
  end

  defp add_box_of_hate do
    {:ok, box} = WallBot.Bucket.start_link([])
    Client.add_handler(WallBot.HateHandler, box)
  end
end
