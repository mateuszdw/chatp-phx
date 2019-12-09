defmodule ChatplayerWeb.MsgView do
  use ChatplayerWeb, :view
  use JaSerializer.PhoenixView

  attributes [:content, :inserted_at]

  has_one :user,
    serializer: ChatplayerWeb.UsersView,
    include: false,
    identifiers: :when_included
end
