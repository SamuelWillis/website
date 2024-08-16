defmodule SamuelWillisWeb.NowLive do
  use SamuelWillisWeb, :live_view

  def render(assigns) do
    ~H"""
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
          Training to ride the
          <.link href="https://www.bcepic1000.com/" rel="noreferrer" target="_blank">BC Epic</.link>
        </li>
        <li>
          Leaning into enjoying yoga 🧘‍♂️
        </li>
        <li>
          Modifying a 1972 Harley-Davidson XLCH
        </li>
      </ul>
      <p class="not-prose text-sm leading-normal text-zinc-600">
        Updated Jun 7, 2024
      </p>
    </article>
    """
  end
end
