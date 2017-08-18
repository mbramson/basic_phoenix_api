defmodule <%= @project_name_camel_case %>.Account.UserTokenService do
  @moduledoc """
  UserTokenService is a utility class for dealing with generating and verifying
  tokens which are associated with users.
  """

  import Ecto.Query, warn: false
  alias <%= @project_name_camel_case %>.{Repo, Types}
  alias <%= @project_name_camel_case %>.Account.{User, UserToken}

  @token_length 64
  @token_second_lifetime 24 * 60 * 60

  @type user_token_types :: :password_reset | :email_confirmation

  @doc """
  Returns a user token for the user with the given email and type. When
  generate_token/2 returns a {:ok, token} tuple, that token wil have also been
  inserted into the database. The UserToken's token field will be a random
  urlsafe base64 encoded string which can the be transmitted safely to the
  user.

  Currently supported types of tokens are :password_reset and
  :email_confirmation.

  If there is no user with that email, generate_token/1 returns an error tuple
  of the form {:error, :no_user_with_email}.
  """
  @spec generate_token(String.t, user_token_types) :: {:ok, Types.user_token} | {:error, atom()}
  def generate_token(email, token_type) when is_binary(email) do
    with {:ok, user} <- get_user_with_email(email),
         {:ok, token} <- create_token(user, token_type),
      do: {:ok, token}
  end
  def generate_token(_, _), do: {:error, :invalid_email}

  @spec get_user_with_email(String.t) :: Types.user | {:error, :no_user_with_email}
  defp get_user_with_email(email) do
    case Repo.get_by(User, %{email: email}) do
      nil -> {:error, :no_user_with_email}
      %User{} = user -> {:ok, user}
    end
  end

  @spec create_token(Types.user, user_token_types) :: Types.user_token | {:error, :invalid_token}
  defp create_token(%User{} = user, token_type) do
    token_string = random_urlsafe_base64()
    token_type = Atom.to_string(token_type)
    changeset = UserToken.changeset(%UserToken{}, %{user_id: user.id, token: token_string, type: token_type})

    case Repo.insert(changeset) do
      {:ok, valid_token} -> {:ok, Repo.preload(valid_token, :user)}
      {:error, _} -> {:error, :invalid_token}
    end
  end

  @spec random_urlsafe_base64() :: String.t
  defp random_urlsafe_base64() do
    @token_length
    |> :crypto.strong_rand_bytes
    |> Base.url_encode64
    |> binary_part(0, @token_length)
  end

  @doc """
  verify_token/2 returns {:ok, token} if a token exists with the given
  token string and token type that has not expired.

  verify_token/2 returns {:error, :invalid_token} if no token with that token
  string and token type is currently in the database, and {:error,
  :token_expired} if a token does exist but it has expired.

  Token are valid for 24 hours after they are created, and then they can no
  longer be used.
  """
  @spec verify_token(String.t, user_token_types) :: {:ok, Types.user_token} | {:error, :token_not_found | :token_expired}
  def verify_token(token_string, token_type) do
    case token_string |> user_token_by_token_string(Atom.to_string(token_type)) |> Repo.one do
      nil -> {:error, :token_not_found}
      %UserToken{} = valid_token ->
        if token_has_expired(valid_token) do
          {:error, :token_expired}
        else
          {:ok, valid_token}
        end
    end
  end

  @spec user_token_by_token_string(String.t, user_token_types) :: Ecto.Query.t
  defp user_token_by_token_string(token_string, token_type) do
    from user_token in UserToken,
    join: user in assoc(user_token, :user),
    where: user_token.token == ^token_string,
    where: user_token.type == ^token_type,
    preload: [user: user]
  end

  @spec token_has_expired(Types.user_token) :: boolean()
  defp token_has_expired(password_reset_token) do
    NaiveDateTime.diff(NaiveDateTime.utc_now, password_reset_token.inserted_at) > @token_second_lifetime
  end
end
