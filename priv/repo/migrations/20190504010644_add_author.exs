defmodule Uncanny.Repo.Migrations.CreateUserCredentials do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      add(:user_id, references(:users), null: false)
    end
  end
end
