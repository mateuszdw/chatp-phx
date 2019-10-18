defmodule Chatplayer.Api do
  @moduledoc """
  The Api context.
  """

  import Ecto.Query, warn: false
  alias Chatplayer.Repo

  alias Chatplayer.Api.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  def get_room(id), do: Repo.get(Room, id)

  def get_room_by_name(room_name) do
    from(r in Room,
      where: r.name == ^room_name,
      limit: 1) |> Repo.one
  end

  def find_or_create_room_by_name(room_name) do
    case get_room_by_name(room_name) do
      nil ->
        {:ok, %Room{} = room} = create_room(%{name: room_name})
        room
      room -> room
    end
  end

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  def get_last_room do
    from(d in Room, limit: 1, order_by: [desc: d.inserted_at]) |> Repo.one
  end

  alias Chatplayer.Api.Msg

  @doc """
  Returns the list of msgs.

  ## Examples

      iex> list_msgs()
      [%Msg{}, ...]

  """
  def list_msgs do
    Repo.all(Msg)
  end

  @doc """
  Gets a single msg.

  Raises `Ecto.NoResultsError` if the Msg does not exist.

  ## Examples

      iex> get_msg!(123)
      %Msg{}

      iex> get_msg!(456)
      ** (Ecto.NoResultsError)

  """
  def get_msg!(id), do: Repo.get!(Msg, id)

  @doc """
  Creates a msg.

  ## Examples

      iex> create_msg(%{field: value})
      {:ok, %Msg{}}

      iex> create_msg(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_msg(attrs \\ %{}) do
    %Msg{}
    |> Msg.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a msg.

  ## Examples

      iex> update_msg(msg, %{field: new_value})
      {:ok, %Msg{}}

      iex> update_msg(msg, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_msg(%Msg{} = msg, attrs) do
    msg
    |> Msg.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Msg.

  ## Examples

      iex> delete_msg(msg)
      {:ok, %Msg{}}

      iex> delete_msg(msg)
      {:error, %Ecto.Changeset{}}

  """
  def delete_msg(%Msg{} = msg) do
    Repo.delete(msg)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking msg changes.

  ## Examples

      iex> change_msg(msg)
      %Ecto.Changeset{source: %Msg{}}

  """
  def change_msg(%Msg{} = msg) do
    Msg.changeset(msg, %{})
  end
end
