defmodule ChatplayerWeb.MsgView do
  use ChatplayerWeb, :view
  use JaSerializer.PhoenixView

  attributes [:content, :inserted_at]
end
