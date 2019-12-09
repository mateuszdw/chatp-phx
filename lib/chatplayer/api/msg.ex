defmodule Chatplayer.Api.Msg do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatplayer.UserManager.{User}


  schema "msgs" do
    field :content, :string
    belongs_to :user, User
    belongs_to :room, Room
    timestamps()
  end

  @doc false
  def changeset(msg, attrs) do
    msg
    |> cast(attrs, [:content, :user_id, :room_id])
    |> validate_required([:content, :user_id, :room_id])
  end
end
