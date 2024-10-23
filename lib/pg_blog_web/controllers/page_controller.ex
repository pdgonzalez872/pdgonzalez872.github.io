defmodule PgBlogWeb.PageController do
  use PgBlogWeb, :controller

  def home(conn, _params) do
    all = PgBlog.Blog.all_posts() |> IO.inspect()
    render(conn, :home, posts: all, layout: false)
  end
end
