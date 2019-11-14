defmodule Chatplayer.UserManager do
  @moduledoc """
  The UserManager context.
  """

  import Ecto.Query, warn: false
  alias Chatplayer.Repo

  alias Chatplayer.UserManager.User

  alias Comeonin.Bcrypt

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def get_first_user do
    from(d in User, limit: 1, order_by: [asc: d.inserted_at]) |> Repo.one
  end

  def get_last_user do
    from(d in User, limit: 1, order_by: [desc: d.inserted_at]) |> Repo.one
  end

  def get_users(list) do
    from(u in User, where: u.id in ^list) |> Repo.all
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

      Chatplayer.UserManager.create_user(%{name: "matt",email: "matt8@o2.pl", password: "12345678", password_confirmation: "12345678"})
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end


  def authenticate_user(email, plain_text_password) do
    query = from u in User, where: u.email == ^email
    case Repo.one(query) do
      nil ->
        Bcrypt.dummy_checkpw()
        {:error, :unauthorized}
      user ->
        if Bcrypt.checkpw(plain_text_password, user.encrypted_password) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end
end
