defmodule Voting.VotingSystem.Option do
  use Ecto.Schema
  import Ecto.Changeset

  schema "options" do
    field :text, :string
    belongs_to :poll, Voting.VotingSystem.Poll
    belongs_to :creator, Voting.Account.User

    timestamps()
  end

  @doc false
  def changeset(option, attrs) do
    option
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end

  def update_changeset(option, attrs) do
    option
    |> cast(attrs, [:text, :creator_id, :poll_id,])
    |> validate_required([:text, :creator_id, :poll_id,])
  end
end
