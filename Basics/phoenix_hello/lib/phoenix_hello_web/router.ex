defmodule PhoenixHelloWeb.Router do
  use PhoenixHelloWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PhoenixHelloWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixHelloWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", PhoenixHelloWeb do
    pipe_through :api

    get "/hello", HelloController, :show
    get "/hello/:name", HelloController, :show
  end
end
