### Rails Girls TO

## Rails 5: Action Cable

##### by Mina Smart @ Shopify

^ Say hello. Introduce yourself.

^ Mention that people can interrupt and ask me to delve into something. I've
been programming for a long time so I'll touch on a lot of little things, but if
you're curious about something, please ask.

---

# Action Cable

^ I'm here to talk to you about the Rails 5 feature, action cable.
So I bet you're all wondering...

---

# Action Cable

![inline](images/what-is-it.jpg)

^ What is it

---

![inline](images/rails.png)

+

Web Sockets

^ Action Cable is a rails interface to websockets. Web sockets? Those aren't
new. Yeah, they're not. But making them usable/scalable/supportable is.
But let's step back a bit. I want to explain why this is important. And why this
is a big thing for rails. To do that, I need to get talk about rails. So.

---

# What the heck is Rails?

^ What is rails? Rails is a web application server. Built using ruby, and on top
of rack. At the most basic level, rails is an HTTP server. So what is HTTP?

---

# HTTP

^ According to wikipedia: The Hypertext Transfer Protocol (HTTP) is an
application protocol for distributed, collaborative, hypermedia information
systems. HTTP is the foundation of data communication for the World Wide Web.
That's not a very concise explanation.

---

# GET, POST, PATCH, PUT, DELETE

^ What this really means for us as Rails devs is that Rails is an application
that responds to requests sent over the network.

---

![inline](images/http.svg.png)

^ Every request is instigated by the client. It uses a descriptive verb.
Optionally sends some data. And the server responds.

---

# The Web

![inline](images/cage-web.png)

^ This is the semantic that the web is built around. This is what makes web
sockets disruptive. They change the relationship between the browser and
the server.

---

![inline](images/ws.svg.png)

^ Web sockets provide a full duplex connection. Clients connect. Clients
message. Servers broadcast. After the initial connection, the server doesn't
have to wait for the client to instigate any action. It can do work, and notify
the client about it. It can receive messages from the client, just like with
HTTP, and tell other clients about what was sent. The canonical demo for this is
Chat.

---

# Demo

^ Show chat app. Don't take a tour of the code yet.

---

# This isn't new

^ OK, Cool. But fundamentally, nothing I've shown you is new. What makes this
interesting is doing this in rails.

---

# Socket.io

![inline](images/node.eps)

# EventMachine

![inline](images/ruby.png)

^ There are existing solutions. The ones I have here are Socket.io (for nodeJS)
and Event Machine (for ruby). As a side note: Event Machine is a really
interesting ruby gem. It gives you a fun way to work with threads and queues
that's a little more user friendly than just `require 'thread'`

^ I haven't seen these projects used very gain a ton of traction or see really
wide spread use. I don't think this is because they're bad, or that there aren't
a lot of use cases for web sockets.  I think it has a lot to do with ecosystem.

---

# Ecosystem

^ Rails has one hell of an ecosystem. It's one of the reasons why so many of us
use it. More than the just the ecosystem, it's the framework.

---

# Framework

- Database
- View layer
- Assets
- MVC
- Background Processing
- Mailers

^ Rails gives us a lot of stuff from the start, (mention points) that none of
these previous approaches (EM, Socket.io) give us. Previous solutions are very
stand alone. There are ways to integrate these into your existing
infrastructure, but they're all home rolled and very custom. Action cable gives
us a nice way to work with everything that exists in rails. So whether you're
building a new app, or adding functionality to an existing application, Action
Cable gives you a happy path to do that.

---

# Use cases

^ There's more than just chat. There are tons of applications we interact with
all day where we're waiting for some sort of information where we're not doing
anything to instigate a server response.

---

# Waiting

![inline](images/waiting.gif)

^ There are so many instances where we wait. On Facebook we upload images, and
eventually get a notification when Facebook finishes processing the image. We
wait for new content to appear at the top of our many social media feeds. On the
social web we spend a lot of time waiting. A more relevant to my job example
would be checkouts. The way most checkouts work is you submit a credit card
number, the server receives, talks to an external service and sends back a
response. This can be bad. First, it busies up your rails workers, so requests
stack up. Wouldn't it be cool to move credit card processing to a background
job, and notify the client when the card charges or declines?

---

# Notifications

![inline](images/fb.png)

^ Another big thing we use web sockets for are notifications. There are a ton of
services we're connected to all the time where we may be doing something, or we
may just have a tab open, but we all want to know the moment something relevant
to us happens.

---

# Implementation

^ In a server architecture, this is difficult to implement. A lot of what drives
notification relies on externalities, so we have to build servers that don't
just respond to events, but servers that are capable of doing some work and then
announcing to the client that something has happened. I'm not even sure how
you'd do this with Rails as it stands today. Action cable makes this a little
bit easier.

---

# How does action cable work?

^ Let's talk a little bit about how action cable works.

---

- Ruby API
- Javascript SDK

^ Action Cable gives the developer two separate APIs. A Ruby API, and a
javascript SDK. The ruby API helps you implement work on the server. The
Javascript SDK lets you build out your clients.

---

- Connections
- Channels
- Streams

^ Internally, Action Cable models websockets using Connections, Channels and
streams. When a client connects, a new connection instance is created. There's
typically only one connection between any browser instance (or tab) and the
server. Channels represent a logical unit of work. The help you segment your
connection into multiple things, so like a chat channel, and a notifications
channel. Streams are how the server segments broadcasting within a channel. When
a client connects to something like a chat room, they'd connect to the chat
channel, the server would figure out what room the client is interested, and
subscribe them to the stream for that room within the chat channel.

---

# Let's look at some code

^ I want to show you another demo, but first let's look at the code for the chat
app. (Start with the rubby. Then move into the Ember. Explain why I've used
Ember. There are a ton of apps that use rails as an API and I wanted to see how
easy it is to do shave out one of rails' layers)

---

#### Rails + Action Cable + Ember = Neato

^ That's still an HTTP-ish example. Every event is precipitated by a client sent
event. The other thing I mentioned was externalities, or where the server has to
do some long running work.

---

![inline fill](images/servers-that-work.jpg)

^ Let's look at another demo, but this time where after a client connects, the
server starts doing some work that doesn't really have an end. It just starts
working and tells the client what's happening.

^ Show streaming demo, then tour code, showing how easy it is to kick off a
thread.

---

# BETA

^ I want to talk a bit about my experience building out these very simple demos.
Action Cable is still very much in beta. The first demo I build was generated
with files in wrong places. The docs didn't really explain too much about how
redis is necessary to back the whole thing. And config files included resources
that didn't exist. That said, there are tons of blogs and demos around that you
can crib from. And the docs are pretty comprehensive and loaded with some
interesting examples.

---

# Resources

- https://github.com/rails/rails/tree/master/actioncable
- https://github.com/minasmart/presentations/tree/master/rails-girls-to-action-cable/

^ Start with the action cable docs, and if you want to see more of my demo code,
or fix some of it, all of this code is on my github.

---

# Questions?

---

# Thanks!

![inline fill](images/thanks.gif)

