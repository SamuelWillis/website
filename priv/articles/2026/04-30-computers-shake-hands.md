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
with the different communication protocols on the internet.

For this echo server, a few basic things are needed:

1. Connections from multiple clients
2. TCP connections
3. UDP connections

When the echo server receives some data, it should send that data back.

# IP? TCP? UDP? 

TCP and UDP are the two primary transport protocols used in the TCP/IP models
(as well as the OSI model).
These two protocols enable communication between computers over a network.

## TCP

THis one is slower but reliable

## UDP

This one is faster

# The server
