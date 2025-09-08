defmodule SamuelWillisWeb.NowLive do
  use SamuelWillisWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} page_visits={@page_visits}>
      <article class="prose prose-zinc">
        <header>
          <h1>
            🔨 What I'm doing now
          </h1>
        </header>
        <p>
          Currently I am:
        </p>
        <ul>
          <li>
            Moving back to Victoria, BC
          </li>
          <li>
            Bulding a 1952 Panhead
          </li>
        </ul>
        <p class="not-prose text-sm leading-normal text-zinc-600">
          Updated September 7, 2025
        </p>
      </article>
    </Layouts.app>
    """
  end
end
