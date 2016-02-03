### Rails Girls TO

## Rails 5: Action Cable

##### by Mina Smart @ Shopify

^ Say hello. Introduce yourself. Tell them what you're presenting (Action Cable)

---

# Action Cable

What's that?

---

![inline](images/rails.png)

+

Web Sockets

^ A rails interface to websockets. Web sockets? Those aren't new.
Yeah, they're not. But making them usable/scalable/supportable is.
But let's step back a bit. I want to explain why this is important. And why this
is a big thing for rails. So first: What's rails?

---

# What the heck is Rails?

^ Rails is a web application server, but simpler than that, it's an HTTP server.

---

# HTTP

^ According to wikipedia: The Hypertext Transfer Protocol (HTTP) is an
application protocol for distributed, collaborative, hypermedia information
systems. HTTP is the foundation of data communication for the World Wide Web.

---

# GET, POST, PATCH, PUT, DELETE

^ What this really means for us as Rails devs is that Rails is an application
that responds to requests sent over TCP.

---

![inline](images/http.svg.png)

^ Every request is instigated by the client. It uses a descriptive verb.
Optionally sends some data. And the server responds.

---

# The Web

![inline](images/the-web.gif)

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

^ Show chat app.
