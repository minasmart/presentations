theme: Poster

# [fit] Hi there!

---

# [fit] Mina Smart

![inline](shopify.png)

^ My name is Mina Smart, and I work at Shopify

---

## Building a GraphQL Client

# In Javascript

^ Today I'm going to talk to you about the work my team and  I have been doing around building a GraphQL client in javascript.

---

# Why?

^ TODO: Maybe remove this slide and the relay and apollo slides and just talk about
our constraints and toss a mention at relay and apollo

^ I'm sure the first question a lot of you have is why am I building a new GraphQL client when we already have libraries like Relay and Apollo. Let's look!

---

# Relay

#### (The library, not the spec)

^ Relay and Relay modern are great tools.

^ If you're building a React UI.

^ The problems that my team solve don't necessarily include a UI. We can't assume there is a UI, or that our client is going to be used in one.

---

# Apollo

^ Now Apollo: When we started working on our own client, Apollo was not where it is today.

^ Apollo's feature set (at the time we built our client) didn't fit our wish list. To an extent, it still doesn't do everything we wanted to accomplish around relay style pagination.

---

# So What Did We need?

^ Let's take a look at some of the features we did need.

---

# Data Only

^ Starting out, we needed a client that was data only and not UI bound.

^ One of the most common questions I got around this was if you're work isn't
necessarily UI bound, why not just use...

---

# Raw Query?

^ A raw query?

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

^ We thought about doing this, but quickly realized that we'd be missing out on a lot of the value GraphQL provides.

---

# Types

^ First off: Types. GraphQL is a strictly typed system. And using only raw queries with an HTTP fetcher we wouldn't be able to get any of this information.

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

^ In the case that we do need to directly render our query results, we store type information about values.

^ This would allow any attached UI to make intelligent choices about how to render data.

---

# Relay

#### (The spec, not the library)

^ The second thing we'd lose out on using only raw queries would be Relay spec features.

^ Relay gives us a whole lot of predictability around refetching resources, and pagination. And in the case of shopify, we have a lot of deeply nested paginated data, and it's much easier to have a computer figure out those pagination queries than to have our developers write it all out manually for every permutation and case.

---

# Pages

```javascript
fetchNextPage(data.shop.collections[0].products[0].variants[0].images).then(images => {
  console.log(images);
});
```

^ We wanted to have the simplicity of an interface like this. Where you can reference a set of resources, ask for the next page of that set, and resolve with only the next page, without having to have the developer traverse the entire object graph.

---

# Reloading

```javascript
reload(data.shop.products[1]).then(product => {
  console.log(product);
});
```

^ We wanted to have a similar interface for reloading. No tree traversal. No query construction.

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

^ We also wanted to avoid client side parsing. Since we're using this library to build other SDKs, we didn't want the weight of a full graphql parser embedded in the client.

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

^ To get an AST without a parser, we built a query builder API. I know a lot of people aren't a fan of this so we also took a hint from the Relay team, and built a babel plugin that can transform a raw query into this syntax.

---

# [fit] Bundled Schema

^ In order to get type data into the objects our client returns, we need access to the type bundle. In fact, it needs to be distributed with the client.

^ However, runtime introspection can be a heavy request and use a ton of memory.

^ Similarly, Including the entire schema would make our distributed js very very big.

---

#### [fit] schema.graphql ⇨ types.js

^ To get around this, we actually analyze the types that the client asks for, and build out a set of terse js modules that return the field types for any field within the object graph.

```javascript
const Product = {
  "name": "Product",
  "kind": "OBJECT",
  "fieldBaseTypes": {
    "collections": "CollectionConnection",
    "descriptionHtml": "HTML",
    "handle": "String",
    "id": "ID",
    "options": "ProductOption",
    "productType": "String",
    "tags": "String",
    "title": "String",
    "variants": "ProductVariantConnection",
    "vendor": "String"
  },
  "implementsNode": true
};

export default Product;
```

^ This does not capture everything that the full schema does, but it's enough for us to figure out field types, and what resources are fetchable under the `node` field.

---

# Decoding

^ So now that we have type information, and an AST of the query, what does this let us do?

^ During the decoding phase, we're able to attach next and previous page queries to connection objects, and abstract out the whole connection architecture, so instead of forcing consumers to look at two types of lists, all lists look the same, but some have additional pagination data associated with them.

---

# Decoding Phases

```javascript
function defaultTransformers({classRegistry}) {
  return [
    transformScalars,
    generateRefetchQueries,
    transformConnections,
    recordTypeInformation,
    transformPojosToClassesWithRegistry(classRegistry)
  ];
}
```

^ Since what we're doing through our decoding process is sort of complex, we actually managed our decode process like a set of middle ware. This allows us to have an extensible interface, so we can add or remove decoding features in the future, without really impacting what already exists in our client

---

# Tooling

^ TODO: Rework this, make it more "What'd we build?"

^ Getting all of these pieces working was a pretty large task for a pretty small team. To get everything built out nicely actually meant building out a few separate bits of tooling to get things working.

---

- graphql-js-client
- graphql-js-schema
- graphql-js-schema-fetch
- babel-plugin-graphql-js-client-transform

^ We have the base client. We have the schema transform tool. A schema introspection tool. The babel transform.

^ Soon we'll be adding more.

---

# The Future

^ TODO: Either scrap this, or move it before tooling

^ What's next?

^ In the future, we've been looking at building graphql compiler, that can take graphql files, and turn them into js modules. Keeping our queries separate could have a few positive side effects, like making it easier for us to profile the types of queries and fields we're actually using.

---

# How'd we do?

^ Building this taught our team a lot about the graphql & relay specs, as well as the graphql language. In the end, we build a client that doesn't do what the popular clients do, but also does some things the popular clients don't. My team also learned the GraphQL language and specification more deeply than we would have otherwise.

^ And why don't y'all tell us how we did?

---

# [fit] Check it out:

# [fit] https://github.com/Shopify/graphql-js-client

^ You can check it out here! See what it does, and tell us what we can do better.

---

## Thanks Everyone!
