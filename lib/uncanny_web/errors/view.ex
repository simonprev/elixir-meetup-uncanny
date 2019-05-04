defmodule UncannyWeb.Errors.View do
  use Phoenix.View, root: "lib/uncanny_web", namespace: UncannyWeb

  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
