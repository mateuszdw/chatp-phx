defmodule ChatplayerWeb.Router do
  use ChatplayerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ChatplayerWeb do
    pipe_through :api
  end
end
