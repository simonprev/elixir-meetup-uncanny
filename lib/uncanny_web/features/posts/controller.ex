defmodule UncannyWeb.Features.Posts.Controller do
  use Phoenix.Controller

  alias Uncanny.Features
  alias Uncanny.Features.Post
  alias UncannyWeb.Permissions.PlugEnsure
  alias UncannyWeb.Router.Helpers, as: Routes

  plug(PlugEnsure, {:list_posts, [], nil} when action === :index)
  plug(PlugEnsure, {:show_post, ["id"], &Features.get_post!/1} when action === :show)
  plug(PlugEnsure, {:update_post, ["id"], &Features.get_post!/1} when action in ~w(edit update)a)
  plug(PlugEnsure, {:create_post, [], nil} when action in ~w(new create)a)
  plug(PlugEnsure, {:delete_post, ["id"], &Features.get_post!/1} when action === :delete)

  def index(conn, _params) do
    posts =
      Features.list_posts()
      |> Features.merge_votes()

    render(conn, "index.html", posts: posts)
  end

  def new(conn, _params) do
    changeset = Features.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}) do
    post_params = Map.put(post_params, "user_id", conn.assigns[:current_user].id)

    case Features.create_post(post_params) do
      {:ok, post} ->
        Phoenix.PubSub.broadcast(
          Uncanny.PubSub,
          "notifications",
          %UncannyWeb.Notification{
            id: Ecto.UUID.generate(),
            text: "New post! #{post.title}",
            author_id: post.user_id
          }
        )

        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = conn.assigns[:resource]
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = conn.assigns[:resource]
    changeset = Features.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = conn.assigns[:resource]

    case Features.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = conn.assigns[:resource]
    {:ok, _post} = Features.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
