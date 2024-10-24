defmodule PgBlogWeb.LinksPlug do
  @behaviour Plug

  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    links =
      if System.get_env("MIX_ENV") == "prod" do
        %{
          app_css_link: "assets/app.css",
          home_link: "/index.html"
        }
      else
        %{
          app_css_link: "/assets/app.css",
          home_link: "/"
        }
      end

    conn
    |> assign(:app_css_link, links[:app_css_link])
    |> assign(:home_link, links[:home_link])
  end
end
