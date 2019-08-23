defmodule Voting.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :avatar_url, :string
    has_many :oauth_member, Voting.Account.OAuthMember
    has_many :polls, Voting.VotingSystem.Poll, foreign_key: :creator_id
    has_many :votes, Voting.VotingSystem.Vote, foreign_key: :creator_id
    has_many :options, Voting.VotingSystem.Option, foreign_key: :creator_id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, ])
    |> validate_required([:username, :email, ])
    |> validate_format(:email, ~r/@/)
  end

end
