defmodule ChatplayerWeb.RoomsView do
  use ChatplayerWeb, :view
  use JaSerializer.PhoenixView

  attributes [:name]

  has_many :msgs,
    serializer: ChatplayerWeb.MsgView,
    include: false,
    identifiers: :when_included
end
