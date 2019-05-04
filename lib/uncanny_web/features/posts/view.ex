defmodule UncannyWeb.Features.Posts.View do
  use Phoenix.View, root: "lib/uncanny_web/features", path: "posts/templates"
  use Phoenix.HTML

  import UncannyWeb.Errors.Helpers

  alias UncannyWeb.Router.Helpers, as: Routes
end
