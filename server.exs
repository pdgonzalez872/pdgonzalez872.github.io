# elixir server.exs
# and then visit: http://localhost:4000/index.html

Mix.install([
  {:plug, "~> 1.14"},
  {:bandit, "~> 1.5.7"}
])

defmodule SimpleServer do
  use Plug.Router

  plug Plug.Static,
    at: "/",
    from: "docs",
    gzip: true,
    cache_control_for_etags: "public, max-age=86400"

  plug :match
  plug :dispatch

  match _ do
    send_resp(conn, 404, "File not found")
  end
end

# Start the Bandit server
{:ok, _} = Bandit.start_link(plug: SimpleServer, port: 4001)
IO.puts("Server running")
Process.sleep(:infinity)
