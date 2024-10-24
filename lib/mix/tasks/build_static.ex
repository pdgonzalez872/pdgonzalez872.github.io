defmodule Mix.Tasks.BuildStatic do
  use Mix.Task

  @shortdoc "Builds the static content"

  def run(_args) do
    Mix.Task.run("app.start")
    IO.puts("Building static site...")

    build_dir = "build"
    File.rm_rf!(build_dir)
    File.mkdir_p!(build_dir)

    generate_page("/", "index.html", build_dir)
    generate_posts(build_dir)
    copy_assets(build_dir)

    IO.puts("Static site generated in #{build_dir}/")
  end

  defp generate_page(path, filename, build_dir) do
    conn = build_conn(path)
    content = conn.resp_body
    File.write!(Path.join(build_dir, filename), content)
    IO.puts("Generated #{filename}")
  end

  defp generate_posts(build_dir) do
    posts = PgBlog.Blog.all_posts()

    Enum.each(posts, fn post ->
      path = "/posts/#{post.id}"
      filename = "#{post.id}.html"

      generate_page(path, filename, build_dir)
    end)
  end

  defp build_conn(path) do
    conn = Plug.Test.conn(:get, path)
    PgBlogWeb.Endpoint.call(conn, [])
  end

  defp copy_assets(build_dir) do
    # Instead of all assets, maybe just copy what we need, which isn't a lot.
    # TODO: HERE
    File.cp_r!("priv/static/.", build_dir)

    File.cp("priv/static/favicon.ico", Path.join([build_dir, "images", "favicon.ico"]))
    |> IO.inspect(label: "cp")
  end
end
