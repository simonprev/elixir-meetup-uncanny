defmodule UncannyWeb.Features.Posts.View do
  use Phoenix.View, root: "lib/uncanny_web/features", path: "posts/templates"
  use Phoenix.HTML

  import Phoenix.LiveView

  import UncannyWeb.Errors.Helpers
  import Uncanny.Permissions, only: [can?: 3]

  alias UncannyWeb.Router.Helpers, as: Routes
end
