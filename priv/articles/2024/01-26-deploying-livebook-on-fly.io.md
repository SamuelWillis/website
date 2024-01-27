%{
  title: "Deploying a Livebook App with Remote Execution Cells on Fly.io",
  author: "Samuel Willis",
  tags: ~w(projects elixir phoenix livebook fly.io deployments networking),
  description: "Deploying a Livebook App with Remote Execution Cells on Fly.io",
  published: true
}
---
In this article I will go over how to deploy a Livebook App with `Smart Remote
Execution` cells that connect to a Fly.io deployed Phoenix App.

To start, this article assumes two things:
1. You have a Fly.io deployed Phoenix Application
2. You want to deploy a Livebook App to Fly.io that executes code remotely on
  the deployed Phoenix Application

You can also see these steps in [this GitHub
gist](https://gist.github.com/SamuelWillis/0d63712a75820074bb4260ea717a0403).

## Configuring Phoenix App

There's a couple things needed to get the Phoenix Application set up to accept
connections.

The first is a `RELEASE_COOKIE` that does not change between deployments and
the second is a reliable `RELEASE_NODE` name.
These will be used by Livebook in order to connect and execute code remotely so
make sure to note them down somewhere you can access them again.

Take care not to expose these values in source code at all though as they could
allow unexpected connections to your node.

1. Generate a cookie
   * In an iex shell run `Base.url_encode64(:crypto.strong_rand_bytes(40))`
2. Set the cookie value in Fly.io
   * Run `fly secrets set RELEASE_COOKIE=$COOKIE`
3. Ensure `RELEASE_NODE` is set in `rel/env.sh.eex`
   * This should be set to something like `"${FLY_APP_NAME}@${FLY_PRIVATE_IP}"`
   * If you do not have this, run `fly launch` to have fly generate it for you,
     make sure it generates based on existing configuration
4. Deploy the application so the `RELEASE_NODE` and `RELEASE_COOKIE` are used
   * Run `fly deploy`
5. Get the node's name by starting a remote `iex` session and taking the value
within the `iex` prompt brackets
   * Run `fly ssh console --pty -C "/app/bin/$APP_NAME remote"`
   * Take the value within the `iex` prompt brackets

## Deploying Livebook App

Now the Livebook you wish to deploy as an App will need to have some
configuration added in order to enable it to connect to the Fly.io deployed
Phoenix App.

1. Update `Smart Remote Execution` cell to get `NODE` and `COOKIE` values from ENV secrets
2. Generate `Dockerfile` with clustering set to `Fly.io`
3. Save `Dockerfile` beside `livemd` file
4. Run `fly launch --no-deploy` to generate config for Livebook App on Fly.io
5. Set ENV `Smart Remote Execution` cell secrets in Fly.io, these will be the
   name of the ENV secret in Livebook prefixed with `LB_`
   * Run `fly secrets set LB_$COOKIE_SECRET_NAME=$COOKIE`
   * Run `fly secrets set LB_$NODE_SECRET_NAME=$NODE_NAME`
6. Set the Livebook password, it must be 12+ characters
   * Run `fly secrets set LIVEBOOK_PASSWORD=$PASSWORD`
7. Deploy with `fly deploy`
8. Visit the output URL with `/apps` appended to it!

And voilà! With this you should be able to access your Livebook App and have it
successfully execute code on the remote Node.

**Note:** If you are saving the `Dockerfile` to GitHub, you might want to
consider removing the potentially sensitive values from it such as the
`LIVEBOOK_COOKIE` and `LIVEBOOK_SECRET_KEY_BASE` and setting those as secrets in
Fly.io as well.

## Conclusion

Getting things connected is really simple once you know all the steps. It took
me quite a long time to figure this out and get everything in place, especially
as the Livebook ecosystem has changed substantially since the Fly.io docs were
written.

If you want to read the source material for this check out [Fly.io's connect to
Livebook
doc](https://fly.io/docs/elixir/advanced-guides/connect-livebook-to-your-app/),
[Fly.io's do interesting things with Livebook
doc](https://fly.io/docs/elixir/advanced-guides/interesting-things-with-livebook/),
and [this
thread](https://community.fly.io/t/unable-to-connect-local-livebook-desktop-to-production-application/17719/2)
I started asking for help!
