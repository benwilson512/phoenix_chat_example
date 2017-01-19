defmodule Chat.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :string
      add :author_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:messages, [:author_id])

  end
end
