defmodule Uncanny.Repo.Migrations.CreatePostVotes do
  use Ecto.Migration

  def change do
    create table(:post_votes) do
      add(:user_id, references(:users), null: false)
      add(:post_id, references(:posts), null: false)
      add(:vote, :integer, null: false)

      timestamps()
    end

    create(unique_index(:post_votes, [:user_id, :post_id]))
  end
end
