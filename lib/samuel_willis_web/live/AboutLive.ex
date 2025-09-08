defmodule SamuelWillisWeb.AboutLive do
  use SamuelWillisWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} page_visits={@page_visits}>
      <article class="prose prose-zinc">
        <h1>
          👋 Hello
        </h1>
        <p>
          I am a Software Engineer currently working at
          <.link class="link link-primary" href="https://www.hiive.com/">Hiive</.link>
        </p>
        <p>
          I am an avid cyclist who can generally be found outside in my off time.
        </p>
        <p>
          Currently residing on the traditional territories of the Skwxwú7mesh-ulh
          Temíx̱w.
        </p>
        <p>
          If you'd like to get in touch you can send me an
          <.link class="link link-primary" href="mailto:hello@samuelwillis.dev=Hey!">email</.link>
          or reach me on
          <.link
            class="link link-primary"
            href="https://www.linkedin.com/in/willissamuel/"
            target="_blank"
            rel="noopener noreferrer"
          >
            LinkedIn
          </.link>
        </p>
      </article>
    </Layouts.app>
    """
  end
end
