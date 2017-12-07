defmodule RequestbxWeb.Router do
  use RequestbxWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RequestbxWeb do
    pipe_through :api

    get "/*path", StoreController, :get
    post "/*path", StoreController, :store
    delete "/*path", StoreController, :destroy
  end
end
