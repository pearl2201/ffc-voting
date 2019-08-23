defmodule Voting.Repo.Migrations.DropVotesText do
  use Ecto.Migration

  def change do
    alter table(:votes) do

      remove :text
    end
  end
end
