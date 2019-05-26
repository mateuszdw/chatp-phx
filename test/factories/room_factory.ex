defmodule Chatplayer.RoomFactory do
  defmacro __using__(_opts) do
    quote do
      def room_factory do
        %Chatplayer.Api.Room{
          name: "valid name"
        }
      end
    end
  end
end
