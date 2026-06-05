%{
  title: "Stop copying me! A simple Echo Server",
  author: "Samuel Willis",
  tags: ~w(projects booklearning smaht learning),
  description: "A simple echo server",
  published: false
}
---

Welcome to the second installment of my manual book learning bootcamp.

Today I am going to talk through a simple TCP Echo Server.

TCP Echo Servers echo back any data it receives to the client, until the client
disconnects.
Check out [RFC 862: STD 20: Echo
Protocol](https://www.rfc-editor.org/info/rfc862/) for the full details.

The goal here is to do a bit of basic network programming and reacquaint myself
with a couple different communication protocols on the internet.

For this echo server, a few basic things are needed:

1. Connections from multiple clients
2. TCP connections
3. UDP connections

When the echo server receives some data, it should send that data back.
It should also allow for multiple connections.

Pretty simple!

# TCP? UDP? 

TCP & UDP are two transport protocols used in both the OSI and TCP/IP models.
They live at the Transport Layer and are responsible for end to end
communication between applications.

This means they define and control: 

1. Segementation and reassembly of data
2. Delivery and error handling
3. Communication speed
4. Flow control
5. Multiplexing

### UDP

The _User Datagram Protocol (UDP)_ is a fire-and-forget protocol and its goal is
to get the packets sent as fast as possible. It does not confirm the packets
arrived.
With UDP, data is wrapped in an 8 byte header and fired away.
There's no connection states, no acknowledgements, and no retransmission.

It's great for when speed is more important than accuracy.

### TCP

The _Transmission Control Protocol (TCP)_ guarantees data is delivered in order,
complete, and without errors.
It does this by establishing a connection before it begins to send packets and
resending any lost packets.

Connections are established with a 3-way handshake. First the client sends a
`SYN` (synchronize) packet, ie: 'I would like to connect'.
The receiver sends a `SYN-ACK` response, ie: 'I am ready'.
The client then confirms with an `ACK`.

Once complete each packet sent gets an `ACK` from the server. If the `ACK` is
not received within a timeout, the packet is retransmitted.

While this is super reliable and accurate, it is much slower than UDP.

# The server

With that out the way let's have a look at the server.

You can view all the code
[here](https://gist.github.com/SamuelWillis/8cae7ec85eed017ec3ff2398017f0bc7)

## Server module

The entry point to the server will be a simple module. It will delegate to a TCP or UDP module as appropriate.

Here it is:

```elixir
defmodule Echo.Server do
  @moduledoc """
  The Server.
  Responsible for opening a listener on the provided port and then accepting
  connections.
  """

  require Logger

  @doc """
  Start listening on the provided port.
  TODO: Implement UDP.
  Unlike TCP, UDP does not "accept" a connection from a client.
  This means it needs to determine who to send the echo back to.
  TCP required adding concurrency to handle multiple connections.
  For UDP, each packet is independent and there are no exclusive connections.
  This means it should be able to handle multiple clients iteratively.
  """
  def listen(port, opts \\ []) do
    Logger.info("Listening on port #{port}")
    protocol = Keyword.get(opts, :protocol, :tcp)

    if protocol == :tcp,
      do: Echo.Server.TCP.echo(port),
      else: Echo.Server.UDP.echo(port)
  end
end
```

## Running the server

The server will be a single elixir script that can be started with TCP via a
`-t` arg.
UDP will be supported with a `-u` arg.
Omitting an argument will default to TCP.


Like this:


```bash
elixir echo_server.exs [-t|-u]
```

Here's how that's handled:

```elixir
case System.argv() do
  [] ->
    Echo.Server.listen(7, protocol: :tcp)

  ["-t"] ->
    Echo.Server.listen(7, protocol: :tcp)

  ["-u"] ->
    Echo.Server.listen(7, protocol: :udp)

  args ->
    raise "Unkown args sepcified: #{inspect(args)}"
end
``` 

## UDP Support

We will start with UDP as it is simpler than TCP. This is because we do not need
to account for concurrent connections.

So for UDP we need to open up the desired port and then accept connections.
When a packet is received we will parse out the relevant information to send
what was received back to it.
We will use erlang's
[gen_udp](https://www.erlang.org/doc/apps/kernel/gen_udp.html) module to support
this.

Like so:

```elixir

defmodule Echo.Server.UDP do
  require Logger

  def echo(port) do
    # Open up the port locally.
    {:ok, socket} =
      :gen_udp.open(port, [:binary, active: false, reuseaddr: true])

    accept(socket)
  end

  @doc """
  Accept UDP clients.

  In contrast to TCP, there is no connection.
  This means that it does not need to account for multiple clients trying to
  connect.

  It does mean that it needs to parse out the client's address + port from the
  packet so it can respond to the correct client.
  """
  defp accept(socket) do
    case :gen_udp.recv(socket, 0) do
      {:ok, {address, port, packet}} ->
        :gen_udp.send(socket, address, port, packet)
        accept(socket)

      error ->
        Logger.error("Error #{error}")
        accept(socket)
    end
  end
end
```

And we're done! Hooray, UDP checked off.

## TCP Support

