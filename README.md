# PgBlog

My turn to overengineer a blog. Even though this is a Phoenix app, this is not
a Phoenix app. I only use it to generate html that works nicely with Tailwind
so I could use Github Pages to host it.

Views here are my own.

## Build

```sh
./build.sh
```

## dev server to test the /docs directory

```elixir
elixir server.exs
```

And visit `http://localhost:4001/index.html`

## dev server while writing the posts

```elixir
mix phx.server
```

## Using Github pages

I have the repo configured to serve files from `/docs`, so that's where I put
the files we generate.
