defmodule SamuelWillisWeb.Router do
  use SamuelWillisWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SamuelWillisWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :track_metrics
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SamuelWillisWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/about", PageController, :about

    resources "/articles", ArticlesController, only: [:index, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", SamuelWillisWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:samuel_willis, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SamuelWillisWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  defp track_metrics(conn, _opts) do
    register_before_send(conn, fn conn ->
      if conn.status == 200 do
        path = "/" <> Enum.join(conn.path_info, "/")

        SamuelWillis.Metrics.track_metrics(path)
      end

      conn
    end)
  end
end
