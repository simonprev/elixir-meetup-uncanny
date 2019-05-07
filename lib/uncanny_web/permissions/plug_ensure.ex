defmodule UncannyWeb.Permissions.PlugEnsure do
  @behaviour Plug

  import Plug.Conn, only: [assign: 3]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Uncanny.Permissions, only: [can?: 3]

  def init(opts), do: opts

  def call(conn, options) do
    access = elem(options, 1)
    target = fetch_target(conn, options)

    if can?(conn.assigns[:current_user], elem(options, 0), target) do
      assign(conn, :resource, target)
    else
      conn
      |> put_flash(:notice, "Sup?")
      |> redirect(to: "/")
    end
  end

  defp fetch_target(_conn, {_, [], _}), do: nil
  defp fetch_target(conn, {_, access, func}), do: func.(get_in(conn.params, access))
end
