defmodule ChatplayerWeb.RoomsView do
  use ChatplayerWeb, :view
  use JaSerializer.PhoenixView

  attributes [:name]
end
