defmodule Voting.VotingSystem do
  import Ecto.Query, warn: false
  require Logger
  require Poison

  alias Voting.Repo

  alias Voting.VotingSystem.Poll
  alias Voting.VotingSystem.Option
  alias Voting.VotingSystem.Vote
  alias Voting.Account.User
  alias Voting.Account

  def list_polls() do
    Repo.all(Poll)
  end

  def get_vote_count(option) do
    query = from v in Vote, where: v.option_id == ^option.id, select: count("*")
    count_votes = Repo.one(query)
    Map.put(option, :votes, count_votes)
  end

  def get_polls(poll_id, nil) do
    poll = Repo.get!(Poll, poll_id)
    query = from o in Option, where: o.poll_id == ^poll_id, select: o
    options = Repo.all(query)
    options = for option <- options, do: get_vote_count(option)

    {poll, options, nil}
  end

  def get_polls(poll_id, user) do
    poll = Repo.get!(Poll, poll_id)
    query = from o in Option, where: o.poll_id == ^poll_id, select: o
    options = Repo.all(query)
    options = for option <- options, do: get_vote_count(option)

    user_option =
      Enum.find(options, fn option ->
        query = from v in Vote, where: v.option_id == ^option.id and v.creator_id == ^user.id

        query
        |> Repo.one()
        |> Kernel.is_nil()
        |> Kernel.not()
      end)

    {poll, options, user_option}
  end

  def change_poll(%Poll{} = user) do
    Poll.changeset(user, %{})
  end

  def create_poll(attrs \\ %{}) do
    %Poll{}
    |> Poll.changeset(attrs)
    |> Repo.insert()
  end

  def create_option(poll_id, option_params \\ %{}, user_id)
      when is_integer(poll_id) and is_integer(user_id) do
    user = Account.get_user!(user_id)
    poll = Repo.get!(Poll, poll_id)

    %Option{}
    |> Option.changeset(option_params)
    |> Ecto.Changeset.put_assoc(:creator, user)
    |> Ecto.Changeset.put_assoc(:poll, poll)
    |> Repo.insert()
  end

  def create_vote(option_id,  user_id) do
    user = Account.get_user!(user_id)
    option = Repo.get!(Option, option_id)

    %Vote{}
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:creator, user)
    |> Ecto.Changeset.put_assoc(:option, option)
    |> Repo.insert()

  end
end
