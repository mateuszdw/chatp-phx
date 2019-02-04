defmodule ChatplayerWeb.UsersView do
  use ChatplayerWeb, :view
  use JaSerializer.PhoenixView

  attributes [:email, :name]

  # def render("index.json", %{pages: pages}) do
  #   %{data: render_many(pages, UsersView, "page.json")}
  # end
  #
  # def render("show.json", %{page: page}) do
  #   %{data: render_one(page, UsersView, "page.json")}
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
