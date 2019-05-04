defmodule UncannyWeb.Pow.SessionView do
  use Phoenix.View, root: "lib/uncanny_web/pow", path: "templates"
  use Phoenix.HTML

  def localize_message(key, opts \\ []) do
    Gettext.dgettext(Uncanny.Gettext, "identities", key, opts)
  end
end
