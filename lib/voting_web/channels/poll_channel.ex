defmodule VotingWeb.PollChannel do
  use Phoenix.Channel

  alias Voting.VotingSystem

  def join("poll:" <> poll_id, _, socket) do
    # [_, poll_id] = Regex.run(~r/^poll:(\d+)$/, socket.topic)
    # poll_id |> String.to_integer |> IO.inspect

    poll_id = String.to_integer(poll_id)
    {:ok, assign(socket, :poll_id, poll_id)}
  end

  @spec handle_in(<<_::32, _::_*72>>, map, Phoenix.Socket.t()) :: {:noreply, Phoenix.Socket.t()}
  def handle_in("create_option", %{"text" => text}, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    poll_id = socket.assigns[:poll_id]
    {:ok, option} = VotingSystem.create_option(poll_id, %{text: text}, user.id)
    IO.inspect(option)

    broadcast!(socket, "new_option", %{
      "option" => %{"text" => option.text, "id" => option.id, "creator_id" => option.creator_id}
    })

    {:noreply, socket}
  end

  def handle_in("vote", %{"option_id" => option_id}, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)

    {:ok, vote} = VotingSystem.create_vote(option_id, user.id)
    IO.inspect(vote)

    broadcast!(socket, "new_vote", %{
      "vote" => %{"id" => vote.id, "creator_id" => vote.creator_id, "option_id" => option_id}
    })

    {:noreply, socket}
  end

  def handle_in("delete_vote", %{"option_id" => option_id}, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)

    case VotingSystem.delete_vote(option_id, user.id) do
      {:ok, vote} ->
        broadcast!(socket, "delete_vote", %{
          "vote" => %{"id" => vote.id, "creator_id" => vote.creator_id, "option_id" => option_id}
        })
    end

    {:noreply, socket}
  end

  def handle_in("info", %{"body" => body}, socket) do
    broadcast!(socket, "info", %{body: body})
    {:noreply, socket}
  end
end
