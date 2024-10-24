defmodule PgBlogWeb.PostController do
  use PgBlogWeb, :controller

  def show(conn, %{"id" => id}) do
    all = PgBlog.Blog.all_posts()
    post = Enum.find(all, &(&1.id == id))

    if post do
      conn
      |> PgBlogWeb.LinksPlug.call([])
      |> render(:show, post: post)
    else
      send_resp(conn, 404, "Not Found")
    end
  end
end
