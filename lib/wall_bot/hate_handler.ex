defmodule WallBot.HateHandler do
  @moduledoc """
  Plugin for putting things in the Box of Hate
  """

  use GenEvent

  alias DogIRC.Command
  alias DogIRC.Client
  alias WallBot.Bucket

  @reg ~r/I hate (.+?)(?:[.!?]|$)/i

  def handle_event(cmd = %Command{type: :privmsg}, box) do
    r_match = Regex.run(@reg, cmd.message)
    if r_match do
      [_, obj] = r_match

      box
      |> Bucket.add(obj)
      |> get_message(obj)
      |> disp_message(cmd.target)
    end

    {:ok, box}
  end

  def handle_event(_, box), do: {:ok, box}

  defp get_message(:nothing, obj) do
    "puts #{obj} in the Box o' Hate"
  end

  defp get_message(ret, obj) do
    "puts #{obj} in the Box o' Hate, but #{ret} falls out!"
  end

  defp disp_message(message, target) do
    Client.me(target, message)
  end
end
