# SamuelWillis

Personal website built with the [Phoenix
Framework](https://www.phoenixframework.org/)

## Getting Started

You'll need to have the following things running to work on this codebase:

1. [direnv](#direnv)
1. [asdf](#asdf) (or Elixir, Erlang, and Node.js)
1. [Postgres](#postgres)

Assuming the above are installed and running correctly

* Copy `.envrc.sample` to `.envrc` and fill out with your configuration
* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with
    `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser and see this wonderful website.

## Deployments

This site is hosted on [Fly.io](https://fly.io/) for super simple deployments.

Deployments happen via GitHub Actions and anything pushed/merged to main is deployed to production.

## Features

This is a small website and only does a couple things.

### Articles

[Nimble Publisher](https://hexdocs.pm/nimble_publisher/NimblePublisher.html) is used for blog posts/articles.

It's super simple to use and all articles are Markdown files stored in this Repo.

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
