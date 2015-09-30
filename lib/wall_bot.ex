defmodule WallBot do
  @moduledoc """
  Main module for wallbot. Handles connecting to channels and setting up plugins
  """

  alias DogIRC.Client


  def main do
    Client.join("#test")
    add_bucket
  end

  defp add_bucket do
    {:ok, bucket} = WallBot.Bucket.start_link
    Client.add_handler(WallBot.BucketHandler, bucket)
  end
end
