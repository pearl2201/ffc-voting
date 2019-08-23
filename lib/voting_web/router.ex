defmodule VotingWeb.Router do
  use VotingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Voting.Account.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/auth", VotingWeb do
    pipe_through [:browser,:auth]

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    post "/logout", AuthController, :delete
  end

  scope "/", VotingWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
  end

  scope "/poll", VotingWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/new", PollController, :new
    post "/create", PollController, :create
    get "/:id", PollController, :show
    post "/:id/option/create", PollController, :create_option
    post "/:id/option/:id", PollController, :vote_option
  end



  # Other scopes may use custom stacks.
  # scope "/api", VotingWeb do
  #   pipe_through :api
  # get "/protected", PageController, :protected
  # end
end
