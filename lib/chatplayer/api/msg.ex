defmodule Chatplayer.Api.Msg do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatplayer.UserManager.User


  schema "msgs" do
    field :content, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(msg, attrs) do
    msg
    |> cast(attrs, [:content, :user_id])
    |> validate_required([:content, :user_id])
  end
end
