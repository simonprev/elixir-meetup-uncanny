defmodule Uncanny.Features.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_votes" do
    field(:vote, :integer)
    belongs_to(:post, Uncanny.Features.Post)
    belongs_to(:user, Uncanny.Identities.User)

    timestamps()
  end
end
