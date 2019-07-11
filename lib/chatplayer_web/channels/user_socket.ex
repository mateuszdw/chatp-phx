defmodule ChatplayerWeb.UserSocket do
  use Phoenix.Socket
  alias Chatplayer.{UserManager, UserManager.User, UserManager.Guardian}

  ## Channels
  channel "room:*", ChatplayerWeb.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.

  def connect(%{"token" => token}, socket) do
    if user = verify_token_and_get_user(token) do
      {:ok, assign(socket, :current_user, user)}
    else
      # everyone can connect
      {:ok, socket}
      # {:error, %{reason: "unauthorized"}}
    end
  end

  # def connect(params, socket) do
  #   IO.inspect params
  #   {:ok, socket}
  # end

  defp verify_token_and_get_user(token) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} -> UserManager.get_user!(claims["sub"])
      {:error, _reason} -> nil
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     ChatplayerWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
