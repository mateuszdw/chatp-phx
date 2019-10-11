defmodule Chatplayer.Api.Msg do
  use Ecto.Schema
  import Ecto.Changeset


  schema "msgs" do
    field :content, :string

    timestamps()
  end

  @doc false
  def changeset(msg, attrs) do
    msg
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
