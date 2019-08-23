defmodule Voting.VotingSystem.Poll do
  use Ecto.Schema
  import Ecto.Changeset

  schema "polls" do
    field :text, :string

    has_many :options, Voting.VotingSystem.Option
    belongs_to :creator, Voting.Account.User
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:text, :creator_id, ])
    |> validate_required([:text, :creator_id, ])
  end

end
