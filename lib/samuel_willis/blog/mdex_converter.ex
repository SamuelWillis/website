defmodule SamuelWillis.Blog.MDExConverter do
  @moduledoc """
  Markdown to HTML conversion powered by MDEx.

  [Docs](https://github.com/dashbitco/nimble_publisher?tab=readme-ov-file#custom-html-converter)
  """
  alias NimblePublisher

  def convert(filepath, body, _attrs, opts) do
    dbg(opts, label: :opts)

    if Path.extname(filepath) in [".md", ".markdown"] do
      highlighters = Keyword.get(opts, :highlighters, [])

      body |> MDEx.to_html!() |> NimblePublisher.highlight(highlighters)
    end
  end
end
