defmodule Voting.Repo.Migrations.Votingsystem do
  use Ecto.Migration

  def change do
    create table(:polls) do
      add :text, :string, null: false
      add :creator_id, references(:users)
      timestamps()
    end

    create table(:options) do
      add :text, :string, null: false
      add :creator_id, references(:users)

      add :poll_id, references(:polls)

      timestamps()
    end

    create table(:votes) do
      add :text, :string, null: false
      add :creator_id, references(:users)

      add :option_id, references(:options)

      timestamps()
    end
  end
end
