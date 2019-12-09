defmodule Chatplayer.Api.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatplayer.Api.Msg

  schema "rooms" do
    field :name, :string
    has_many :msgs, Msg
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
