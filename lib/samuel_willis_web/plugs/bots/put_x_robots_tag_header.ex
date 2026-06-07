defmodule SamuelWillisWeb.Plugs.Bots.PutXRobotsHeader do
  @moduledoc """
  Sets X-Robots-Tag header to opt out of AI training.

  See [X-Robots-Tag header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/X-Ro bots-Tag).
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    put_resp_header(conn, "x-robots-tag", "noai, noimageai")
  end
end
