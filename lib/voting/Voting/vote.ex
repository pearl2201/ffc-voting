defmodule Voting.VotingSystem.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "votes" do
    belongs_to :creator, Voting.Account.User
    belongs_to :option, Voting.VotingSystem.Option
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [])
  end
end
