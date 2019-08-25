defmodule VotingWeb.PageController do
  use VotingWeb, :controller

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    polls = Voting.VotingSystem.list_polls()
    IO.inspect("access index")
    render(conn, "index.html", current_user: current_user, polls: polls)
  end

  def user_index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    polls = Voting.VotingSystem.list_user_polls(current_user.id)
    IO.inspect("access index")
    render(conn, "index.html", current_user: current_user, polls: polls)
  end
end
