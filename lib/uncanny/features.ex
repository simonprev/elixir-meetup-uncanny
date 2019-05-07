defmodule Uncanny.Features do
  @moduledoc """
  The Features context.
  """

  import Ecto.Query, warn: false
  alias Uncanny.Repo

  alias Uncanny.Features.{Post, Vote}

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def merge_votes(posts) do
    ids = Enum.map(posts, & &1.id)

    votes =
      from(votes in Vote, group_by: votes.post_id, select: {votes.post_id, sum(votes.vote)}, where: votes.post_id in ^ids)
      |> Repo.all()
      |> Map.new(& &1)

    posts = Map.new(posts, &{&1.id, &1})

    Enum.reduce(votes, posts, fn {post_id, vote}, posts ->
      update_in(posts, [post_id], fn
        nil -> nil
        post -> %{post | votes_score: vote}
      end)
    end)
    |> Map.values()
    |> Enum.reject(&is_nil/1)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id), do: Repo.get!(Post, id)

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, %Post{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{source: %Post{}}

  """
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end
end
