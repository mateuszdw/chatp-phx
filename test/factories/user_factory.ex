# alias Comeonin.Bcrypt

defmodule Chatplayer.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Chatplayer.UserManager.User{
          email: sequence(:email, &"email-#{&1}@example.com"),
          name: "valid name",
          encrypted_password: Bcrypt.hash_pwd_salt("password")
        }
      end
    end
  end
end
