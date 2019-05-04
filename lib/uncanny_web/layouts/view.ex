defmodule UncannyWeb.Layouts.View do
  use Phoenix.View, root: "lib/uncanny_web", path: "layouts/templates", namespace: UncannyWeb
  use Phoenix.HTML

  import Phoenix.Controller, only: [get_flash: 2]

  alias UncannyWeb.Router.Helpers, as: Routes
end
