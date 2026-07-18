# SamuelWillis

Personal website built with the [Phoenix
Framework](https://www.phoenixframework.org/)

## Getting Started

To start your Phoenix server:

* Install required tools (via mise)
* Setup your `.env` values based on `.env.sample`
* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with
    `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser
and see this wonderful website.

## Deployments

This site is hosted on [Fly.io](https://fly.io/) for super simple deployments.

Deployments happen via GitHub Actions and anything pushed/merged to main is
deployed to production.

## Features

This is a small website and only does a couple things.

### Articles

[Nimble Publisher](https://hexdocs.pm/nimble_publisher/NimblePublisher.html) is
used for blog posts/articles.

It's super simple to use and all articles are Markdown files stored in this
Repo.

You can see them at [`priv/articles`](./priv/articles).

### Metrics

This website gathers metrics. The driving factors for the Metrics system
are/were:

1. To see what pages are being looked at
2. Have a small Ecto based project to get done
3. Not give people's data to the big nastys
4. Not spend money on Metric gather

With the above I decided to implement a small metrics gathering system that
saves some basic information into a database.

The information gathered is:

1. The date
2. The path
3. The number of visits

This lets me see the total number of visits to a page on a given day.

No PII or anything like that and super simple.
It's mainly used to power the small `page_views` counter at the bottom right
hand of the website's pages.
Pretty neat huh?

Metrics are tracked via [a Plug](./lib/samuel_willis_web/plugs/track_metrics.ex)
on static pages and [a Hook](./lib/samuel_willis_web/hooks/track_metrics.ex) on
LiveView pages.

### Game Of Life

Implementation of [Conway's Game of
Life](https://conwaylife.com/wiki/Conway%27s_Game_of_Life).

It is visible at the `life.` subdomain.

The universe of the Game of Life is an infinite two-dimensional orthogonal grid
of square cells, each of which is either live or dead.

Each cell interacts with its 8 neighbours, ie: the cells directly horizontally,
vertically, or diagonally adjecent.

At each step in time, the following transitions occur:

1. Any live cell with fewer than two live neighbours dies, known as
    _underpopulation_ or _exposure_
1. Any live cell with more than three live neighbours dies, known as
    _overpopulation_ or _overcrowding_.
1. Any live cell with two or three ive neighbours lives, unchanged, to the next
    generation.
1. Any dead cell with exactly three live neighbours will come to life.

The game starts with an initial pattern, known as a _seed_, and the above rules
are applied simultaneously to every cell.
An application of the rules is called a _generation_ and rules are continuously
applied to create further generations.

#### Todo

After my ugly first pass I would like to:

1. Add some rendering
    * How to render between states, it's opaque right now!
    * Maybe the Universe is a GenServer with its own state and it broadcasts generations
    * THe above idea is sorta good, start the universe, stop the universe, step the universe
    * dyanmic spawn needed, Genserver per universe.
1. Make it a little more performant?
    * Only store the alive cells?
    * Do a flattened list of the cells?
1. Add some dynamic components?
    * Board sizes?
    * Different seeds?
    * Choose your own seeds?

