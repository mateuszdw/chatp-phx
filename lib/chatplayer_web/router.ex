defmodule ChatplayerWeb.Router do
  use ChatplayerWeb, :router

  # Our pipeline implements "maybe" authenticated. We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :ensure_auth do
    plug Chatplayer.UserManager.Pipeline
    plug Guardian.Plug.EnsureAuthenticated
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
    plug :accepts, ["json","json-api"]
    # plug JaSerializer.ContentTypeNegotiation
    # plug JaSerializer.Deserializer
  end

  scope "/", ChatplayerWeb do
    pipe_through [:api, :ensure_auth]

    resources "/msgs", MsgController, except: [:new, :edit]
    resources "/rooms", RoomsController
    get "/users/me", UsersController, :profile
  end

  scope "/", ChatplayerWeb do
    pipe_through [:api]

    post "/sign_up", UsersController, :sign_up
    post "/sign_in", UsersController, :sign_in
    post "/logout", UsersController, :logout
  end

  # fallback to rest request only for aurelia-authorization

  scope "/rest", ChatplayerWeb do
    pipe_through [:api]

    post "/sign_up", UsersRestController, :sign_up
    post "/sign_in", UsersRestController, :sign_in
    post "/logout", UsersRestController, :logout
  end

  scope "/rest", ChatplayerWeb do
    pipe_through [:api, :ensure_auth]
    get "/users/me", UsersRestController, :profile
  end
end
