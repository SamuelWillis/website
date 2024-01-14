defmodule SamuelWillisWeb.PageController do
  use SamuelWillisWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end

  def about(conn, _params) do
    render(conn, :about)
  end

  def now(conn, _params) do
    render(conn, :now)
  end
end
