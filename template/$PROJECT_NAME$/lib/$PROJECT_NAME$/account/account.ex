defmodule <%= @project_name_camel_case %>.Account do
  @moduledoc """
  The boundary for the Account system.
  """

  import Ecto.Query, warn: false
  alias <%= @project_name_camel_case %>.{Repo, Types}
  alias <%= @project_name_camel_case %>.Account.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  @spec list_users() :: [Types.user]
  def list_users do
    Repo.all(User)
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
  @spec get_user!(integer()) :: Types.user | no_return
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user. Returns nil if no user is found.
  """
  @spec get_user(integer()) :: Types.user | nil
  def get_user!(id), do: Repo.get(User, id)

  @doc """
  Retrieves the user that has the given email. Forces the email to be lowercase
  before comparison.

  If no user is found with that email, it returns nil.
  """
  @spec get_user_by_email(any) :: Types.user | nil
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: String.downcase(email))
  end
  def get_user_by_email(_), do: nil

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  @spec create_user(map()) :: {:ok, Types.user} | {:error, Ecto.Changeset.t}
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
  @spec update_user(Types.user, map()) :: {:ok, Types.user} | {:error, Ecto.Changeset.t}
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates a user profile. Used by any action which allows a user to update
  their own information. Does not allow the update of any properties related to
  the user's privileges.
  """
  @spec update_user_profile(Types.user, map()) :: {:ok, Types.user} | {:error, Ecto.Changeset.t}
  def update_user_profile(%User{} = user, attrs) do
    user
    |> User.profile_changeset(attrs)
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
  @spec delete_user(Types.user) :: {:ok, Types.user} | {:error, Ecto.Changeset.t}
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  @spec change_user(Types.user) :: Ecto.Changeset.t
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
