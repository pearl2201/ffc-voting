defmodule VotingWeb.PollController do
  use VotingWeb, :controller

  alias Voting.VotingSystem.Poll

  def index(conn, _params) do
    conn
    |> redirect(to: "/")
  end

  def new(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    changeset = Voting.VotingSystem.change_poll(%Poll{:creator => current_user})

    render(conn, "new.html", changeset: changeset, current_user: current_user)
  end

  def create(conn, %{"poll" => poll_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    poll_params = Map.put(poll_params, "creator_id", current_user.id)
    IO.inspect(poll_params)

    case Voting.VotingSystem.create_poll(poll_params) do
      {:ok, poll} ->
        conn
        |> redirect(to: Routes.poll_path(conn, :show, poll))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, current_user: current_user)
    end
  end

  def create_option(conn, %{"poll" => poll_params, "option" => option_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    IO.inspect(poll_params)

    case Voting.VotingSystem.create_option(poll_params, option_params, current_user) do
      {:ok, poll} ->
        conn
        |> redirect(to: Routes.poll_path(conn, :show, poll))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, current_user: current_user)
    end
  end

  def vote_option(conn, %{"poll" => poll_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    poll_params = Map.put(poll_params, "creator_id", current_user.id)
    IO.inspect(poll_params)

    case Voting.VotingSystem.create_poll(poll_params) do
      {:ok, poll} ->
        conn
        |> redirect(to: Routes.poll_path(conn, :show, poll))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, current_user: current_user)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)
    current_token = Guardian.Plug.current_token(conn)

    {poll, options, user_option} = Voting.VotingSystem.get_polls(id, current_user)

    render(conn, "show.html",
      poll: poll,
      options: options,
      user_option: user_option,
      current_user: current_user,
      token: current_token
    )
  end
end
