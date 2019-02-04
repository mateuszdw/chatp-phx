defmodule ChatplayerWeb.RoomView do
  use ChatplayerWeb, :view
  use JaSerializer.PhoenixView

  attributes [:name]
end
