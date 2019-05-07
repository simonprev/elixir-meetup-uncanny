defmodule Uncanny.Repo.Migrations.AddDescriptionText do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify(:description, :text, null: false)
    end
  end
end
