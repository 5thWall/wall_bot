defmodule WallBot.BucketHandler do
  @moduledoc """
  Plugin for DogIRC which creates and handles a bucket of items
  """

  use GenEvent

  @reg ~r/(?:gives|hands) wallbot (.+)/i

  alias DogIRC.Command
  alias DogIRC.Client
  alias WallBot.Bucket

  def init(bucket) do
    {:ok, bucket}
  end

  def handle_event(cmd = %Command{type: :action}, bucket) do
    IO.puts("Got an action: #{cmd.message}")
    r_match = Regex.run(@reg, cmd.message)
    if r_match do
      r_match
      |> get_object(bucket)
      |> get_message
      |> disp_exchange(cmd.target)
    end

    {:ok, bucket}
  end

  def handle_event(event, bucket) do
    IO.puts("Got something else")
    IO.puts(inspect event)
    {:ok, bucket}
  end

  def handle_call(_, bucket), do: {:ok, bucket}

  defp get_object([_, object], bucket) do
    ret_object = Bucket.add(bucket, object)
    {object, ret_object}
  end

  defp get_message({obj, :nothing}) do
    "takes #{obj}"
  end

  defp get_message({obj, new_obj}) do
    "takes #{obj} and but drops #{new_obj}"
  end

  defp disp_exchange(message, target) do
    Client.me(target, message)
  end
end
