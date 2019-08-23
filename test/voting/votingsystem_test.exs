defmodule Voting.VotingSystemTest do
  use Voting.DataCase

  alias Voting.Account.User
  alias Voting.VotingSystem
  alias Voting.VotingSystem.Poll
  alias Voting.VotingSystem.Option
  alias Voting.Repo



  setup do

    user = %User{} |> User.changeset(%{email: "nguyenanhngoc.ftu@gmail.com", username: "test1"}) |> Repo.insert!()
    poll_attrs = %{text: "poll text", creator_id: user.id}
    poll = VotingSystem.create_poll(poll_attrs)
    IO.inspect("Setup success")
    IO.inspect(Repo.all(User))
    :ok
  end

  @option_attrs  %{text: "test"}


  test "create option" do
    IO.inspect("Test create option")


    user = Repo.all(User) |> Enum.at(0)
    poll = Repo.all(Poll) |> Enum.at(0)
    {:ok, option} = VotingSystem.create_option(poll.id, @option_attrs, user.id )
    

    assert option.text != nil
    assert option.text == @option_attrs.text
    assert option.creator_id == user.id
    assert option.poll_id == poll.id

  end
end
