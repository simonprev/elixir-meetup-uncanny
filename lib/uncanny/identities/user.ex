defmodule Uncanny.Identities.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  schema "users" do
    field(:name, :string)

    pow_user_fields()

    timestamps()
  end

  def changeset(%User{} = user, attributes) do
    required_fields = ~w(name)a

    user
    |> pow_changeset(attributes)
    |> cast(attributes, required_fields)
    |> validate_required(required_fields)
  end
end
