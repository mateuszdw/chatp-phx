defmodule Chatplayer.Factory do
  use ExMachina.Ecto, repo: Chatplayer.Repo
  use Chatplayer.UserFactory
end
