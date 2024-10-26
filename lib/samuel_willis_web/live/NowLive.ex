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
          Practicing Yoga 🧘‍♂️
        </li>
        <li>
          Avoiding bicycles after completing the
          <.link href="https://www.bcepic1000.com/" rel="noreferrer" target="_blank">BC Epic</.link>
          with my brother
        </li>
        <li>
          Building a vintage chopper in my garage out of a 1952 Harley-Davidson FLH
        </li>
      </ul>
      <p class="not-prose text-sm leading-normal text-zinc-600">
        Updated Oct 26, 2024
      </p>
    </article>
    """
  end
end
