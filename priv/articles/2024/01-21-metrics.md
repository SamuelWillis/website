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

To get started [install Livebook Desktop locally](https://livebook.dev/#install)
if you haven't already.
The local instance of Livebook will be used to connect to a local development
server and validate our Livebook app works before deploying to Fly.io.

Open up a new Livebook and save it in a directory called `livebooks/` at the
root of your Phoenix project.

Open up a new Livebook in this directory and save it.

In order to make the data somewhat consumable and provide the user some inputs
to manipulate what is displayed the [Kino](https://hexdocs.pm/kino/Kino.html),
[KinoExplorer](https://hexdocs.pm/kino_explorer/Kino.Explorer.html), and
[KinoVegaLite](https://hexdocs.pm/kino_vega_lite/Kino.VegaLite.html)
dependencies will be needed.

`Kino` will handle I/O, `KinoExplorer` will enable rendering data from
`Explorer.DataFrames`, and `KinoVegaLite` will handle charting the data.

Add the following to the Livebook set up block:

```elixir
Mix.install([
  {:kino, "~> 0.12.0"},
  {:kino_vega_lite, "~> 0.1.10"},
  {:kino_explorer, "~> 0.1.11"}
])
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

Finally, lets provide some context for the user about what is going on.
Above the `Smart Remote Execution Cell` add an Elixir block and have it render
some markup like so:

```elixir
Kino.Shorts.markdown("""
# Website Analytics

## Load metrics
Load the metrics from website database
""")
```

## Creating a table

Now that the Metrics are loaded, they need formatting into something that can be
easily read.

As a simple starting example, lets build a table displaying the date and the
total visits that day.

To start, add an Elixir block and render some markdown for the user:

```elixir
Kino.Shorts.markdown("""
## Daily visits
Table showing the visits per day
""")
```

The table itself can be trivially built with the `Smart Data Transformation`
cell but it's also very simple to do with `Explorer` so lets add a new Elixir
block and get started.

```elixir
require Explorer.DataFrame

# Create a new DataFrame out of the metrics
metrics_df = Explorer.DataFrame.new(metrics)

# Group by 'date', aggregate 'visits', and sort by desc dates
metrics_df
|> Explorer.DataFrame.group_by([:date])
|> Explorer.DataFrame.summarise(total_visits: sum(visits))
|> Explorer.DataFrame.sort_by(desc: date)
```

This will output a formatted table that can be sorted by the date or visits
column!

## Creating a chart

For a more complicated example, lets create a chart that shows the number of
vists per day, broken down by path.

To further the interactivity, lets allow the user to choose to select today's,
the last seven days, and last months site visits.

First a `Kino` input will be needed along with a header.

Add a new elixir block with the following:

```elixir
# Add some markdown and render it.
markdown = Kino.Shorts.markdown("""
## Daily visits by path
Chart displaying the number of visits per day, broken down by path visited.
""")
Kino.render(markdown)

# Set up select options
today = Date.utc_today()
seven_days_ago = Date.add(today, -8)
thirty_days_ago = Date.add(today, -31)
options = [{today, "Today"}, {seven_days_ago, "Last seven days"}, {thirty_days_ago, "Last 30 days"}]

# Create a select input
time_period_input = Kino.Input.select("Time period", options, default: seven_days_ago)

# Render the select
Kino.render(time_period_input)
```

This will render a select input on the page that allows selecting the time
range.

Now we need to take the selected time range and find the relevant metrics.

```elixir
# Get the selected date range
time_period_selected = Kino.Input.read(time_period_input)

# Find the relevant metrics
metrics_from_time_period = Enum.filter(
  metrics,
  & Date.compare(&1.date, time_period_selected) == :gt
)
```

The `metrics_from_time_period` variable will contain all the metrics for the
days in the date range, however it's possible there's missing days if there were
no site visits.

So for our chart to display a full date range some backfilling of dates will be
needed.

```elixir
# Create a DataFrame containing all dates in the time period
# Set each date to have a default value that will render nothing in the chart.
date_range_df =
  time_period_selected
  |> Date.add(1)
  |> Date.range(Date.utc_today())
  |> Enum.map(& %{date: &1, path: "/", visits: 0})
  |> Explorer.DataFrame.new()

# Create a DataFrame consisting of metrics from time period
metrics_from_time_period_df = Explorer.DataFrame.new(metrics_from_time_period)

# Concatinate the two dataframes, preferring existing entries in the
# metrics_from_time_period_df
metrics_from_time_period_df  = Explorer.DataFrame.concat_rows(
  metrics_from_time_period_df,
  date_range_df
)
```

Now, we have a DataFrame containing the metrics for the day or a default value
if there are no metrics for a specific date.

This DataFrame can now be turned into a lovely chart with VegaLite:

```elixir
VegaLite.new(width: 700, height: 500)
|> VegaLite.data_from_values(metrics_from_time_period_data_frame)
|> VegaLite.mark(:bar)
|> VegaLite.encode_field(:x, "date", type: :ordinal)
|> VegaLite.encode_field(:y, "visits", type: :quantitative)
|> VegaLite.encode_field(:color, "path")
```

Now the chart will render based on the selected time period when the app is
revaluated.

We now have a simple Livebook application that will render data in a consumable
form. This is only the start and there's plenty of refining that could be done,
but for now it's good enough!

## Deploying to Fly.io

Deploying this to Fly.io is super simple.

First, get the generated Dockerfile from Fly.io.
This is done by clicking the rocket icon, in the side bar then clicking the `→
Deploy with Docker` link.

From there set the clustering configuration to `Fly.io` and save the generated
Dockerfile alongside your notebook.

Open up the Dockerfile in your editor and remove the lines that specify the
`LB_REMOTE_NODE_NAME` and `LB_REMOTE_COOKIE` as their values will need to be
adjusted and saved as runtime variables in Fly.io.

The `LIVEBOOK_COOKIE` and `LIVEBOOK_SECRET_KEY_BASE` can also be removed but
make sure to store their values later as they will also need to be configured as
secrets in Fly.io.


