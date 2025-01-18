defmodule Mix.Tasks.BuildStatic do
  use Mix.Task

  @shortdoc "Builds the static content"

  def run(_args) do
    IO.puts("Booting app")
    Mix.Task.run("app.start")

    IO.puts("Start building /docs static")

    IO.puts("Create directory")
    build_dir = "build"
    File.rm_rf!(build_dir)
    File.mkdir_p!(build_dir)

    IO.puts("Create static pages")
    generate_page("/", "index.html", build_dir)
    generate_page("/resume_technical", "resume_technical.html", build_dir)
    generate_page("/recommendations", "recommendations.html", build_dir)

    IO.puts("Create posts - add them in priv/posts/")

    PgBlog.Blog.all_posts()
    |> Enum.each(fn post ->
      path = "/posts/#{post.id}"
      filename = "#{post.id}.html"

      generate_page(path, filename, build_dir)
    end)

    IO.puts("Copy assets")
    File.cp_r!("priv/static/.", build_dir)

    IO.puts("Finished building /docs")
  end

  defp generate_page(path, filename, build_dir) do
    conn = Plug.Test.conn(:get, path)
    %{resp_body: body} = PgBlogWeb.Endpoint.call(conn, [])

    build_dir
    |> Path.join(filename)
    |> File.write!(body)

    IO.puts("Created #{filename}")
  end
end
