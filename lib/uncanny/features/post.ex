defmodule Uncanny.Features.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:description, :string)
    field(:title, :string)
    belongs_to(:user, Uncanny.Identities.User)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :user_id])
    |> validate_required([:title, :description, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
