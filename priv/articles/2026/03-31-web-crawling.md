%{
  title: "The files are actually on another computer. Web Crawling 101",
  author: "Samuel Willis",
  tags: ~w(projects booklearning smaht learning elixir breadth-first-search),
  description: "Web crawling but very very simple.",
  published: false
}
---

The first bit of inspiration for this learning journey was this
[/r/dailyprogrammer Web Crawler
challenge](https://www.reddit.com/r/dailyprogrammer/comments/7dlaeq/20171117_challenge_340_hard_write_a_web_crawler/).

Admittedly, I also saw some posts about Anthropic's [webcrawler interview
challenge](https://www.linkjob.ai/interview-questions/anthropic-coding-interview/)
and wondered if I'd be able to implement something for it.

*TL;DR:* See the full code [here](https://github.com/SamuelWillis/crawler).

## The challenge

You can read the full reddit post for the complete description but in a nutshell
the challenge was to build a webcrawler that supports:

* HTTP/1.1 client behaviors
* GET requests 
* Parsing all links presented in HTML - anchors, images, scripts, etc
* Accepts a starting (seed) URL
* Accepts a maximum depth to recurse to (e.g. "1" would be fetch the HTML page
  and all resources like images and script associated with it but don't visit
  any outgoing anchor links; a depth of "2" would visit the anchor links found
  on that first page only, etc ...)
* Does not visit the same link more than once per session

## First pass

This took me longer than I care to admit...

After getting way too distracted by choosing the best HTML parser in the Elixir
ecosystem I realized I was letting minutia distract me from attempting to solve
the prompt (I used [Floki](https://hexdocs.pm/floki/Floki.html)...)

On the first pass I hit the following:

* HTTP/1.1 client behaviours
* GET requests are the only method you must support
* Do not visit the same link more than once

Then I hit a little bonus of doing the requests concurrently. Which was an
enjoyable sidequest in the Elixir ecosystem.

I also did a little bit of benchmarking between the sync and concurrent version.
Concurrent was faster...

At this point I got distracted reading up about TCP, HTTP, and TLS until I wrote
this article and put a little more into it.

## Some code

I ended up going with a recursive solution, I thought it read much nicer and
leaned into Elixir's strengths.

A simple API entry point was provided to hideaway the internal mechanics:

```elixir
defmodule WebCrawler do
  @moduledoc """
  Entry point for crawlin'

  https://crawler-test.com/
  """

  def crawl(url) do
    uri = URI.new!(url)
    
    [uri]
    |> crawl([])
    |> Enum.map(&URI.to_string/1)
    |> Enum.frequencies()
  end
end
```

Then the recursion was relatively simple:

```elixir
defmodule WebCrawler do
  # Base: no more URIs to visit
  defp crawl([] = _visit, visited) do
    visited
  end
  
  # Process a batch of URIs
  defp crawl(visit, visited, context) do
    %{current_depth: current_depth} = context

    requests =
      for uri <- visit do
        Task.async(fn ->
          %Req.Response{body: body} = Req.get!(Req.new(url: uri))

          body
          |> Floki.parse_document!()
          |> Floki.find("a[href]")
          |> Enum.map(&Floki.attribute(&1, "href"))
          |> Enum.map(&hd/1)
          |> Enum.map(&String.replace_suffix(&1, "/", ""))
          |> Enum.map(&URI.merge(uri, &1))
          |> Enum.reject(&(&1.host != uri.host))
        end)
      end

    visited = visit ++ visited

    uris_to_visit =
      requests
      |> Task.await_many()
      |> List.flatten()
      |> Enum.reject(&(&1 in visited))

    crawl(uris_to_visit, visited)
  end
end
```

**A note:** An astute reader may notice that the above concurrency is bound by the
slowest request... There's improvements to be made.

## Adding depth limits

Off the top of my head, adding a depth that supports a breadth first search
should not be terribly difficult and would require:

1. The specification of the max depth
2. Tracking the current depth
3. Bailing out when the max depth is reached

Something like this:

```elixir
defmodule WebCrawler do
  def crawl(url, opts \\ []) do
    uri = URI.new!(url)
  
    max_depth = Keyword.get(opts, :max_depth, :infinity)
  
    context = %{
      current_depth: 0,
      max_depth: max_depth
    }
  
    [uri]
    |> crawl([], context)
    |> Enum.map(&URI.to_string/1)
    |> Enum.frequencies()
  end
  

  defp crawl([], visited, _opts) do
    visited
  end

  # At max depth
  defp crawl(visit, visited, %{current_depth: max_depth, max_depth: max_depth}) do
    # Here the visited URIs AND the URIs to visit are returned to satisfy this
    # behaviour:
    # Accepts a maximum depth to recurse to (e.g. "1" would be fetch
    # the HTML page and all resources like images and script associated with it
    # but don't visit any outgoing anchor links;
    visited ++ visit
  end
  
  defp crawl(visit, visited, context) do
     %{current_depth: current_depth} = context
     
     #...
     
    new_context = %{context | current_depth: current_depth + 1}
    crawl(new_anchor_uris, uris_to_visit ++ visited, new_context)
  end
end
``` 

The above is a [breadth-first search](https://en.wikipedia.org/wiki/Breadth-first_search).
Breadth-first search specifies that all nodes at the current depth are processed
before moving onto the next depth level.

Since the recursive case processes all the URIs found by the previous recursion,
the above is true.

To illustrate, say that `$URI_A` has links to `$URI_B` and `$URI_C`. `$URI_B`
links to `$URI_D` and `$URI_C` links to `$URI_E`

With a max depth of 0, then `vistied = []`, `visit = [$URI_A]`,
and all URIs at depth 0 have been visited, ie: none.

With a max depth of 1, then `vistied = [$URI_A]`, `visit = [$URI_B, $URI_C]`,
and all URIs at depth 1 have been visited.

With a max depth of 2, then `vistied = [$URI_A, $URI_B, $URI_C]`, `visit =
[$URI_D, $URI_E]`, and all URIs at depth 1 have been visited.

And so on.

## What I learnt

I hadn't really appreciated how fundamental webcrawling is to a massive chunk of the internet.
Which seems silly in hindsight...

Webcrawling as a challenge is also quite intersting and this provided a very small peek into that world.
Skimming this [crawler-test.com](https://crawler-test.com/) site shows a mass of edge cases to handle.

There's also some really cool optimization

## What's next

Well, in doing the above I realized that it's been a very long time since I've
really thought about HTTP, TLS, and how communication happens on the internet!

So a likely diversion into refreshing my TCP knowledge with a small project will
be next.

Thanks for tuning in!
