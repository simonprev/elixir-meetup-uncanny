defmodule UncannyWeb.Router do
  use Phoenix.Router
  use Pow.Phoenix.Router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug(:accepts, ["html", "json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug Phoenix.LiveView.Flash
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:put_layout, {UncannyWeb.Layouts.View, :app})
  end

  scope "/" do
    pipe_through(:browser)

    pow_session_routes()
  end

  scope "/", UncannyWeb do
    pipe_through(:browser)

    get("/", Features.Posts.Controller, :index, as: :home)
    resources("/posts", Features.Posts.Controller, as: :post)
  end
end
