defmodule PgBlogWeb.PageController do
  use PgBlogWeb, :controller

  def home(conn, _params) do
    all = PgBlog.Blog.all_posts()

    if System.get_env("MIX_ENV") == "prod" do
      all = Enum.map(all, fn p -> Map.put(p, :link, "#{p.id}.html") end)

      conn
      |> render(:home, posts: all)
    else
      all = Enum.map(all, fn p -> Map.put(p, :link, "/posts/#{p.id}") end)

      conn
      |> render(:home, posts: all)
    end
  end
end
