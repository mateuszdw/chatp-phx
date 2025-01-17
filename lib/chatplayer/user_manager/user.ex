defmodule Chatplayer.UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chatplayer.Api.Msg

  schema "users" do
    field :email, :string
    field :name, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_many :msgs, Msg

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :password_confirmation])
    |> validate_required([:email, :name, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, encrypted_password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
