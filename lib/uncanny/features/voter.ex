defmodule Uncanny.Features.Voter do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    has_many(:votes, Uncanny.Features.Vote, foreign_key: :user_id)
    has_many(:post, through: [:votes, :post])
  end
end
