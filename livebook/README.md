# Livebooks

This directory contains the Livebook files used as applications.

## Set up

To set these up you will need Livebook installed on your machine.

Open up Livebook and add the `WEBSITE_RELEASE_NODE` and
`WEBSITE_RELEASE_COOKIE` to your hub, or session.

With that done, open up any of the `.livemd` files in this directory with
Livebook.

If you wish to create new livebook for deployment, start a new `.livemd` and
then deploy the changes.

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

This livebook is deployed to Fly.io and connects to the production site.

If you are getting the website set up for the first time or need to reconfigure
the livebook connection [follow this
gist](https://gist.github.com/SamuelWillis/0d63712a75820074bb4260ea717a0403).

The livebook apps will be deployed as part of the CD process so simply commiting
and pushing your changes will suffice.

However, to deploy manually simply run `fly deploy` from this directory.
