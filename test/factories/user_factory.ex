alias Comeonin.Bcrypt

defmodule Chatplayer.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Chatplayer.UserManager.User{
          email: "aaaa@test.com",
          password: Bcrypt.hashpwsalt("password")
        }
      end
    end
  end
end
