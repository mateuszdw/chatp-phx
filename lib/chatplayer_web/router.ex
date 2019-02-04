defmodule ChatplayerWeb.Router do
  use ChatplayerWeb, :router

  # Our pipeline implements "maybe" authenticated. We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :auth do
    plug Chatplayer.UserManager.Pipeline
  end
  #
  # # We use ensure_auth to fail if there is no one logged in
  # pipeline :ensure_auth do
  #   plug Guardian.Plug.EnsureAuthenticated
  # end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    # plug :accepts, ["json"]
    plug :accepts, ["json-api"]
    # plug JaSerializer.ContentTypeNegotiation
    # plug JaSerializer.Deserializer
  end

  scope "/", ChatplayerWeb do
    pipe_through [:api, :auth]

    resources "/rooms", RoomController, except: [:new, :edit]

    resources "/users", UsersController, only: [:show]
    post "/sign_up", UsersController, :create
    post "/login", UsersController, :login
    post "/logout", UsersController, :logout
  end
end



#
# # Maybe logged in routes
# scope "/", AuthMeWeb do
#   pipe_through [:browser, :auth]
#
#   get "/", PageController, :index
#
#   get "/login", UsersController, :new
#   post "/login", UsersController, :login
#   post "/logout", UsersController, :logout
# end
#
# # Definitely logged in scope
# scope "/", AuthMeWeb do
#   pipe_through [:browser, :auth, :ensure_auth]
#
#   get "/secret", PageController, :secret
# end
