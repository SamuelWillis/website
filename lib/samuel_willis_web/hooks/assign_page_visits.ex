defmodule SamuelWillisWeb.Hooks.AssignPageVisits do
  @moduledoc """
  AssignPageVisits Hook

  Responsible for ensuring page_visits is assigned on LiveViews
  """
  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket),
    do: {:cont, attach_hook(socket, :assign_page_visits, :handle_params, &assign_page_visits/3)}

  defp assign_page_visits(_params, uri, socket) do
    uri = URI.parse(uri)

    page_visits = SamuelWillis.Metrics.get_path_visits(uri.path)

    {:cont, assign(socket, :page_visits, page_visits)}
  end
end
