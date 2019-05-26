defmodule Chatplayer.Factory do
  use ExMachina.Ecto, repo: Chatplayer.Repo
  use Chatplayer.UserFactory
  use Chatplayer.RoomFactory
end
