defmodule Voting.OAuthAccount do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  require Logger
  require Poison



  alias Voting.Repo
  alias Bcrypt
  alias Voting.Account.User
  alias Voting.Account.OAuthMember
  alias Ueberauth.Auth

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def authenticate_user(username, plain_text_password) do
    query = from u in User, where: u.username == ^username

    case Repo.one(query) do
      nil ->
        {:error, :invalid_credentials}

      user ->
        IO.inspect(plain_text_password)
        IO.inspect(user.encrypted_password)

        if Bcrypt.verify_pass(plain_text_password, user.encrypted_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  @doc """
  Find or create user with oauth
  """
  def find_or_create(%Auth{} = auth) do
    query =
      from u in OAuthMember,
        where: u.provider == ^Atom.to_string(auth.provider) and u.provider_user_id == ^auth.uid

    case Repo.one(query) do
      nil ->
        IO.puts("no oath member found")

        case Repo.get_by(User, email: auth.info.email) do
          nil ->
            {:ok, user} = %User{username: auth.info.name, email: auth.info.email, avatar_url: auth.info.image} |> Repo.insert()

            oauthMember =
              Ecto.build_assoc(user, :oauth_member, %{
                provider: Atom.to_string(auth.provider),
                provider_user_id: auth.uid
              })

            Repo.insert!(oauthMember)
            {:ok, user}

          user ->
            oauthMember =
              Ecto.build_assoc(user, :oauth_member, %{
                provider: Atom.to_string(auth.provider),
                provider_user_id: auth.uid
              })

            Repo.insert!(oauthMember)
            {:ok, user}
        end

      oauthMember ->
        case Repo.get!(User, oauthMember.user_id) do
          nil ->
            {
              :error,
              :invalid_credentials
            }

          user ->
            {:ok, user}
        end
    end
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
