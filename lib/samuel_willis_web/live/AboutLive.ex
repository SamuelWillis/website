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
          I am a Software Engineer currently working with Laravel, Vue.JS, and
          a sprinkle of Python.
        </p>
        <p>
          I am also an avid cyclist who can generally be found outside in my off time.
        </p>
        <p>
          Currently residing on the traditional territories of the Skwxwú7mesh-ulh
          Temíx̱w.
        </p>
        <p>
          If you'd like to get in touch you can send me an email or reach me on
          LinkedIn by clicking the icons below.
        </p>
      </article>
    </Layouts.app>
    """
  end
end
