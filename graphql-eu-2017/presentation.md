theme: Poster

# [fit] Hi there!

---

# [fit] Mina Smart

![inline](shopify.png)

^ My name is Mina Smart, and I work at Shopify

---

## Building a GraphQL Client

# In Javascript

^ Today I'm going to talk to you a little bit about the work my team and  I have
been doing around building a graphql client in javascript.

---

# Why?

^ I'm sure the first question a lot of you have is why am I building a new
graphql client when we have things like Relay and Apollo. Let's look!

---

# Relay

#### (The library, not the spec)

^ Relay and Relay modern are great tools. If you're building a React UI. The
problems my team is solving don't necessarily rely on a UI. We can't assume
there is one, or that our client will ever be close to it.

---

# Apollo

^ Now apollo: When we started working on our own client, Apollo was not where it
is today. Apollo's feature set (at the time we built our client) didn't fit our
wish list, so we decided to build our own!

---

# So What Did We need?

---

# Data Only

^ Starting out, we needed a client that was data only, and not UI bound.

^ But if we needed a data only client, that's not UI bound, why not just use...

---

# Raw Query?

---

```javascript
fetch('https://buckets.myshopify.com/api/graphql', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/graphql',
    'Accept': 'application/javascript',
  },
  body: `
    query {
      shop {
        name
        products(first: 10) {
          title
          price
        }
      }
    }
  `
});
```

^ We thought about doing this, but we quickly realized that there's a lot to
graphql that we'd be missing out on

---

# Types

^ First off: Types. GraphQL is a strictly typed system. And doing only raw
queries we wouldn't be able to get any of this 

---

```javascript
render(product.price);

function render(value) {
  switch (graphQLType(value)) {
    case 'Money':
      return `$${value}`;
    case 'HTML':
      return value.toString();
    default: // default -> String
      return HTMLEscape(value);
  }
}
```

^ We store type information about values, which allows our view layer to make
intelligent choices about how to render data.

---

# Relay

#### (The spec, not the library)

^ Second: Relay! (the spec). Relay gives us a whole lot of predictability around
refetching resources, and pagination. And in the case of shopify, we have a lot
of deeply nested paginated data, and it's much easier to have a computer figure
out those pagination queries than to have our developers write it all out
manually for every permutation and case.

---

# Pages

```javascript
fetchNextPage(data.shop.collections[0].products[0].variants[0].images).then(images => {
  console.log(images);
});
```

^ We wanted to have the simplicity of an interface like this. Where you can
reference a set of resources, ask for the next page of that set, and resolve
with only the next page, without having to have the developer traverse the
entire object graph.

---

# Reloading

```javascript
relead(data.shop.products[1]).then(product => {
  console.log(product);
});
```

^ We wanted to have a similar interface for reloading. No tree traversal. No
query construction.

---

# Type Aware?

^ Without a type-aware client we couldn't have done any of this.

---

# Client Side Parsing

```javascript
const query = gql`query {
  shop {
    name
  }
}`;
```

^ We also wanted to avoid client side parsing. Since we're using this library to
build other SDKs, we didn't want the weight of a full graphql parser embedded in
the client.

---

# AST

^ To do this, we needed an AST of the query.

---

## Query Building API

```javascript

const query = client.query((root) => {
  root.add('shop', (shop) => {
    shop.add('name');
  });
});

```

^ To get an AST without a parser, we built a query builder API. I know a lot of
people aren't a fan of this so we also took a hint from the Relay team, and
built a babel plugin that can transform a raw query into this syntax.

---

# [fit] Bundled Schema

^ In order to get type data into the data our client returns, we need access to
the type bundle. In fact, it needs to be distributed with the client.

^ However, runtime introspection can be a heavy request and use a ton of memory.

---

#### [fit] schema.graphql ⇨ types.js

^ To get around this, we actually analyze the types that the client asks for,
and build out a set of terse js modules that return the field types for any
field within the object graph.

---

# Bringing it all together

^ Building this taught our team a lot about the graphql & relay specs, as well
as the graphql language. In the ent, we build a client that doesn't do what the
popular clients do, but also does some things the popular clients don't.

---

# [fit] Check it out:

# [fit] https://github.com/Shopify/graphql-js-client

^ We actually built out all the features I've talked about here. We may end up
building up a client side cache, as well as some more generic graphql tools.
It's all still under active development, so check it out here!
