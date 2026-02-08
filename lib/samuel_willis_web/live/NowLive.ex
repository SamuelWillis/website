defmodule SamuelWillisWeb.NowLive do
  use SamuelWillisWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} page_visits={@page_visits}>
      <article class="prose prose-zinc">
        <header>
          <h1>
            🔨 What I'm doing now
          </h1>
        </header>
        <ul>
          <li>
            Moving back to Victoria, BC
          </li>
          <li>
            Building a 1952 Panhead
          </li>
        </ul>
        <p class="not-prose text-sm leading-normal text-zinc-600">
          Updated Feb 7, 2026
        </p>
      </article>
    </Layouts.app>
    """
  end
end
