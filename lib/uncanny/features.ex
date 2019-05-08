defmodule Uncanny.Features do
  @moduledoc """
  The Features context.
  """

  import Ecto.Query, warn: false
  alias Uncanny.Repo

  alias Uncanny.Features.{Post, Vote, Voter}

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    Repo.all(Post)
  end

  def post_voters(post) do
    Repo.all(from(voters in Voter, join: posts in assoc(voters, :post), where: posts.id == ^post.id))
  end

  def increment_post_vote(post, user) do
    update_post_vote(%{
      post_id: post.id,
      user_id: user.id,
      vote: 1
    })
  end

  def decrement_post_vote(post, user) do
    update_post_vote(%{
      post_id: post.id,
      user_id: user.id,
      vote: -1
    })
  end

  def update_post_vote(vote) do
    now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

    vote =
      Map.merge(
        %{
          inserted_at: now,
          updated_at: now
        },
        vote
      )

    Repo.insert_all(Vote, [vote], on_conflict: {:replace, ~w(vote updated_at)a}, conflict_target: ~w(user_id post_id)a)
  end

  def post_with_user(post) do
    Repo.preload(post, :user)
  end

  def post_votes_for_user(posts, user) do
    ids = Enum.map(posts, & &1.id)

    from(votes in Vote, select: {votes.post_id, votes.vote}, where: votes.post_id in ^ids and votes.user_id == ^user.id)
    |> Repo.all()
    |> Map.new(& &1)
  end

  def merge_votes(posts) do
    ids = Enum.map(posts, & &1.id)
    posts = Map.new(posts, &{&1.id, &1})

    from(votes in Vote, group_by: votes.post_id, select: {votes.post_id, sum(votes.vote)}, where: votes.post_id in ^ids)
    |> Repo.all()
    |> Map.new(& &1)
    |> Enum.reduce(posts, fn {post_id, vote}, posts ->
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
