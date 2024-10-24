defmodule PgBlog.Blog do
  defmodule Parser do
    def parse(_path, contents) do
      {:ok, doc} = Floki.parse_document(contents)

      attrs = %{
        title: extract_text(doc, "#title"),
        author: extract_text(doc, "#author"),
        description: extract_text(doc, "#description"),
        tags: extract_text(doc, "#tags") |> String.split(",", trim: true),
        id: extract_text(doc, "#id")
      }

      {attrs, contents}
    end

    defp extract_text(doc, id) do
      doc |> Floki.find(id) |> Floki.text()
    end
  end

  alias PgBlog.Blog.Post

  use NimblePublisher,
    build: Post,
    from: Application.app_dir(:pg_blog, "priv/posts/**/*.html"),
    as: :posts,
    parser: Parser,
    highlighters: [:makeup_elixir]

  # The @posts variable is first defined by NimblePublisher.
  # Let's further modify it by sorting all posts by descending date.
  @posts Enum.sort_by(@posts, & &1.date, {:desc, Date})

  # Let's also get all tags
  @tags @posts |> Enum.flat_map(& &1.tags) |> Enum.uniq() |> Enum.sort()

  # And finally export them
  def all_posts, do: @posts
  def all_tags, do: @tags
end
