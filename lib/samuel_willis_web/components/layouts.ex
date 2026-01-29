defmodule SamuelWillisWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use SamuelWillisWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  attr :page_visits, :integer, doc: "the number of page visits"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="flex justify-between p-4">
      <h1 class="text-2xl font-bold">
        <.link
          navigate={~p"/"}
          class="link link-primary link-hover"
        >
          Samuel Willis
        </.link>
      </h1>
      <.theme_toggle />
    </header>

    <main class="flex flex-1 md:w-full max-w-prose mt-8 mx-6 sm:mx-8 md:mx-auto">
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />

    <footer class="grid grid-cols-3 items-center p-4">
      <div class="col-start-2 justify-self-center">
        <.social_links />
      </div>

      <div class="hidden sm:block col-start-3 justify-self-end">
        <.page_visits visits={@page_visits} />
      </div>
    </footer>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=lofi]_&]:left-1/3 [[data-theme=lofidark]_&]:left-2/3 transition-[left]" />

      <button
        class="btn btn-sm btn-circle"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="btn btn-sm btn-circle"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="lofi"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="btn btn-sm btn-circle"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="lofidark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end

  attr :visits, :integer, required: true

  def page_visits(assigns) do
    ~H"""
    <aside class="flex items-center space-x-2">
      <p>
        Page Views:
        <div class="badge badge-primary">{@visits}</div>
      </p>
    </aside>
    """
  end

  def social_links(assigns) do
    ~H"""
    <nav>
      <ul class="flex justify-center gap-x-5">
        <li>
          <.link
            href="https://github.com/SamuelWillis"
            target="_blank"
            rel="noopener noreferrer"
            class="link link-primary link-hover"
          >
            <svg class="fill-current w-10 h-10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 98 96">
              <path
                fill-rule="evenodd"
                d="M48.854 0C21.839 0 0 22 0 49.217c0 21.756 13.993 40.172 33.405 46.69 2.427.49 3.316-1.059 3.316-2.362 0-1.141-.08-5.052-.08-9.127-13.59 2.934-16.42-5.867-16.42-5.867-2.184-5.704-5.42-7.17-5.42-7.17-4.448-3.015.324-3.015.324-3.015 4.934.326 7.523 5.052 7.523 5.052 4.367 7.496 11.404 5.378 14.235 4.074.404-3.178 1.699-5.378 3.074-6.6-10.839-1.141-22.243-5.378-22.243-24.283 0-5.378 1.94-9.778 5.014-13.2-.485-1.222-2.184-6.275.486-13.038 0 0 4.125-1.304 13.426 5.052a46.97 46.97 0 0 1 12.214-1.63c4.125 0 8.33.571 12.213 1.63 9.302-6.356 13.427-5.052 13.427-5.052 2.67 6.763.97 11.816.485 13.038 3.155 3.422 5.015 7.822 5.015 13.2 0 18.905-11.404 23.06-22.324 24.283 1.78 1.548 3.316 4.481 3.316 9.126 0 6.6-.08 11.897-.08 13.526 0 1.304.89 2.853 3.316 2.364 19.412-6.52 33.405-24.935 33.405-46.691C97.707 22 75.788 0 48.854 0z"
                clip-rule="evenodd"
              />
            </svg>
          </.link>
        </li>
        <li>
          <.link
            href="https://www.linkedin.com/in/willissamuel/"
            target="_blank"
            rel="noopener noreferrer"
            class="link link-primary link-hover"
          >
            <svg class="fill-current w-10 h-10" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
              <path d="M19 0h-14c-2.761 0-5 2.239-5 5v14c0 2.761 2.239 5 5 5h14c2.762 0 5-2.239 5-5v-14c0-2.761-2.238-5-5-5zm-11 19h-3v-11h3v11zm-1.5-12.268c-.966 0-1.75-.79-1.75-1.764s.784-1.764 1.75-1.764 1.75.79 1.75 1.764-.783 1.764-1.75 1.764zm13.5 12.268h-3v-5.604c0-3.368-4-3.113-4 0v5.604h-3v-11h3v1.765c1.396-2.586 7-2.777 7 2.476v6.759z" />
            </svg>
          </.link>
        </li>
        <li>
          <.link
            href="mailto:hello@samuelwillis.dev=Hey!"
            class="link link-primary link-hover pt-2 pb-3"
          >
            <.icon name="hero-envelope" class="w-10 h-10" />
          </.link>
        </li>
      </ul>
    </nav>
    """
  end
end
