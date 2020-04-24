defmodule ChatplayerWeb.UsersRestView do
  use ChatplayerWeb, :view

  def render("show.json", %{user: user, token: token}) do
    %{id: user.id, name: user.email, avatar: "", token: token}
  end

  def render("show.json", %{user: user}) do
    %{id: user.id, name: user.email, avatar: avatar(user)}
  end

  def avatar(user) do
    avatar_hash = :crypto.hash(:md5, user.email) |> Base.encode16(case: :lower)
    "https://www.gravatar.com/avatar/#{avatar_hash}?d=identicon"
  end

  # def render("index.json", %{users: users}) do
  #   %{data: render_many(users, ChatplayerWeb.UsersRestView, "page.json")}
  # end
  #
  # def render("show.json", %{user: user}) do
  #   %{data: render_one(user, ChatplayerWeb.UsersRestView, "page.json")}
  # end
  #
  # def render("page.json", %{page: page}) do
  #   %{title: page.title}
  # end
end

# defmodule Chatplayer.UsersView do
#
#   def render("user.json", %{user: user}) do
#     %{id: user.id, email: user.email, is_active: user.is_active}
#   end
#
# end
