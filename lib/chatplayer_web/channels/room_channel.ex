defmodule ChatplayerWeb.RoomChannel do
  use ChatplayerWeb, :channel
  alias Chatplayer.{Api, UserManager, UserManager.User, UserManager.Guardian, Repo}
  alias ChatplayerWeb.{UsersView, RoomsView, MsgView, UserPresence}

  # this channel is public
  # def join("room:purgatory", _message, socket) do
  #   {:ok, socket}
  # end
  def join("room:" <> name, params, socket) do
    send(self(), :user_joined)
    case Api.find_or_create_room_by_name(name) do
      nil -> {:error, %{reason: "not found"}}
      room ->
        socket = assign(socket, :current_room, room)
        {:ok, JaSerializer.format(RoomsView, room, %{}), socket}
    end
  end

  def handle_in("take_msgs", %{}, socket) do
    if room = socket.assigns.current_room do
      room = room |> Repo.preload(:msgs)
      msgs = room.msgs |> Repo.preload(:user)
      serializer = JaSerializer.format(MsgView, msgs, %{}, include: "user")
      {:reply, {:ok, serializer}, socket}
    end
  end

  def handle_info(:user_joined, socket) do
    if user = socket.assigns.current_user do
      push(socket, "presence_state", UserPresence.list(socket))
      {:ok, _} = UserPresence.track(socket, user.id, %{
        online_at: inspect(System.system_time(:second)),
        devise: :browser,
        name: user.name
      })
    end
    {:noreply, socket}
  end

  # def join("room:" <> room_slug, params, socket) do
    # IO.inspect room_slug
    # IO.inspect params
    # Api.get_room!(room_id)
    # user = socket.assigns.current_user
    # user = UserManager.get_last_user
    # serializer = JaSerializer.format(RoomView, user)
    # if user do
    #   {:ok, serializer, socket}
    # else
    #   {:error, %{reason: "authorization required to enter this room #{room_id}"}}
    # end
  # end
  # this room is for user which don't have correct room_id
  # def join("room:purgatory", _message, socket) do
  #
  # end


  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("send_msg", %{"content" => msg}, socket) do
    if user = socket.assigns.current_user do
      {:ok, new_msg} = Api.create_msg(%{content: msg, user_id: user.id, room_id: socket.assigns.current_room.id})
      new_msg_with_user = new_msg |> Repo.preload(:user)

      broadcast!(socket, "new_msg", JaSerializer.format(MsgView, new_msg_with_user, %{}, include: "user"))
      {:reply, :ok ,socket}
      # {:reply, {:ok, JaSerializer.format(MsgView, new_msg_with_user)}, socket}
    else
      {:error, %{reason: "not logged in"}}
    end
  end
end
