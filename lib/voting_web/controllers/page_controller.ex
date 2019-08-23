defmodule VotingWeb.PageController do
  use VotingWeb, :controller

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    polls = Voting.VotingSystem.list_polls()
    render(conn, "index.html", current_user: current_user, polls: polls)
  end
end
