%{
  title: "Using Livebook deployed on Fly.io as an analytics dashboard",
  author: "Samuel Willis",
  tags: ~w(projects elixir phoenix analytics livebook),
  description: "Visualizing website analytics with Livebook deployed on Fly.io",
  published: false
}
---
In this article I will show how I use Livebook as a website analytics visualizer
for my this website deployed on [Fly.io](https://fly.io)

## A note before starting

When I created this website I wanted to some insights into how much this site
was being viewed and which pages were/are viewed the most.

I also wanted to achieve this without unnecessarily tracking my site's visitors
which meant no cookies and excluded many mainstream - and free - analytics offerings.

While there are some privacy focused analytics offerings like [Fathom
Analytics](https://usefathom.com/) and
[Plausible](https://plausible.io/privacy-focused-web-analytics) they are paid
services (rightfully so since they're not harvesting and selling data).

With this being a small personal project, my focus is on _free_...

Thus, I ended up rolling my own analytics based on this [brilliant Dashbit
article](https://dashbit.co/blog/homemade-analytics-with-ecto-and-elixir) and
the entirety of this article is focused on building a visualizer in Livebook for
these home rolled analytics.

This article was also prompted by seeing a lot of articles saying that you
_can_ use Livebook for this purpose, but none showing how!

With that out of the way, lets start.

## Getting started

To get started [install Livebook Desktop locally](https://livebook.dev/#install).
The local instance of Livebook will be used to connect to a local development
server and validate our Livebook app works before deploying to Fly.io.

Open up a new Livebook and save it in a directory called `livebooks/` at the
root of your Phoenix project.

Open up a new Livebook in this directory and save it.

To start, add an `Elixir` cell that will render some markup in our deployed
application:

```elixir
Kino.Shorts.markdown("""
# Website Analytics

## Load metrics
Load the metrics from website database
""")
```

## Getting Metrics from remote server

The next thing needed is the actual metrics from our Phoenix Application.
This will require configuring our local server to run with a specific node name
and cookie so that we can connect to the server and execute code remotely from
Livebook.

Livebook's `Smart Remote Execution` cell makes connecting to a remote node easy
but there's a bit of set up needed to get this working locally, and in
production.

For now, let's focus on setting up our local environment.

Step one is to start up a local `phx.server` with a `sname` and `cookie`.

```bash
# From your phoenix app root directory
iex --sname website --cookie cookie -S mix phx.server
```

Once this has started, grab the node's full name from the `iex` prompt.
It will appear within the brackets on the prompt line like so:

```bash
iex(website@$COMPUTER_NAME)1>
```

You will use the node's full name as the value for the `Smart Remote Execution`
cell's `NODE` and the value of the `--cookie` in the `iex` command for the
`COOKIE` value.

To make deployments easier, configure the cell to use a secret stored in your
Hub for both the `NODE` and `COOKIE`.
For this article's purposes the secrets will be called `REMOTE_NODE_NAME`
and `REMOTE_COOKIE`.

Now that the node is connected, load up the metrics and configure the `Smart
Remote Execution` cell to assign the result to a variable called `metrics`!

```elixir
import Ecto.Query, only: [from: 2]

alias YourApp.Metrics.Metric
alias YourApp.Repo

# Query for metrics and select only the important fields without struct meta
query = from m in Metric,
  order_by: [desc: m.date],
  select: %{
    date: m.date,
    path: m.path,
    visits: m.visits,
  }

Repo.all(query)
```

Here's an image showing the cell and its set up:

![alt Smart Remote Execution Cell image](/images/articles/2024/01/smart-cell.png)

## Creating a chart

- Create a chart
- Reduce the time duration
- Setting up an input to select some options and change the chart

## Creating a table

- Creating a table
- Reduce the
