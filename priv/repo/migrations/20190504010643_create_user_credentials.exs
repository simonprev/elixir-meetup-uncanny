defmodule Uncanny.Repo.Migrations.CreateUserCredentials do
  use Ecto.Migration

  def change do
    create table(:user_credentials) do
      add(:user_id, references(:users), null: false)
      add(:namespace, :string, null: false)
      add(:key, :string, null: false)

      timestamps()
    end

    create(unique_index(:user_credentials, [:namespace, :key]))
  end
end
