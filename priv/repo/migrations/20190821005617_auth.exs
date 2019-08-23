defmodule Voting.Repo.Migrations.Auth do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false

      add :avatar_url, :string

      timestamps()
    end

    create table(:oauth_member) do
      add :provider, :string, null: false
      add :provider_user_id, :string, null: false

      add :user_id, references(:users)

      timestamps()
    end

    create unique_index(:users, [:email,:username])
  end
end
