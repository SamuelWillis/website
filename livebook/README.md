# Livebooks

This directory contains the Livebook files used as applications.

## Set up

To set these up you will need Livebook installed on your machine.

Open up Livebook and add the `WEBSITE_RELEASE_NODE` and
`WEBSITE_RELEASE_COOKIE` to your hub, or session.

With that done, open up any of the `.livemd` files in Livebook.

### Connecting to local website

To connect these Livebook apps to a local instance, start up the website with a
command like the following:

```elixir
iex --sname samuel_willis --cookie secret -S mix phx.server
```

Then set the `WEBSITE_RELEASE_NODE=samuel_willis` and
`WEBSITE_RELEASE_COOKIE=secret`

### Connecting to production site

Connecting to production is roughly the same but you will need to find the node
name from production, namely you will need the `RELEASE_NODE` and
`RELEASE_COOKIE` values from production.

## Deployment

The livebook apps will be deployed as part of the CD process so simply commiting
and pushing your changes will suffice.

However, to deploy manually simply run `fly deploy` from this directory.
