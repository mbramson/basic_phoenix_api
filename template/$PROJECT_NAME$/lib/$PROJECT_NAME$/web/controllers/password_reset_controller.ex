defmodule <%= @project_name_camel_case %>.Web.PasswordResetController do
  use <%= @project_name_camel_case %>.Web, :controller

  alias <%= @project_name_camel_case %>.Repo
  alias <%= @project_name_camel_case %>.Account.{User, UserTokenService}

  action_fallback <%= @project_name_camel_case %>.Web.PasswordResetFallbackController

  @doc """
  The password_reset :create action creates a UserToken with a type of
  :password_reset if there is a User with the given email. It also sends an
  email to that user if the send_password_reset_email method is implemented to
  do so.

  This action always reports that an email was sent, even if that email was not
  associated with a user and no token was generated. This is to prevent a bad
  actor from probing this endpoint until they find an email associated with a
  user.
  """
  @spec create(Plug.Conn.t, map()) :: Plug.Conn.t
  def create(conn, %{"email" => email}) do
    with {:ok, token} <- UserTokenService.generate_token(email, :password_reset),
         _ <- send_password_reset_email(token),
      do: render_successful_create(conn)
  end
  def create(conn, _) do
    conn
    |> put_status(:bad_request)
    |> render("no_email_received.json")
  end

  @spec render_successful_create(Plug.Conn.t) :: Plug.Conn.t
  defp render_successful_create(conn) do
    conn
    |> put_status(:created)
    |> render("email_sent.json")
  end

  @spec send_password_reset_email(Types.user_token) :: any
  defp send_password_reset_email(_token) do
    {:error, :not_implemented}
  end

  @doc """
  The password_reset :show action reports whether a given password reset token
  is valid or not.

  This is useful when the front-end would like to verify whether a token is
  valid so that it can decide whether or not to show the form allowing the user
  to reset their password.
  """
  @spec show(Plug.Conn.t, map()) :: Plug.Conn.t
  def show(conn, %{"token" => token}) do
    with {:ok, _valid_token} <- UserTokenService.verify_token(token, :password_reset),
      do: render_successful_show(conn)
  end

  @spec render_successful_show(Plug.Conn.t) :: Plug.Conn.t
  defp render_successful_show(conn) do
    conn
    |> put_status(:ok)
    |> render("valid_token.json")
  end

  @doc """
  The password_reset :update action accepts a token string and a desired new
  password. If the token is valid, then the user associated with that token's
  password is updated to the desired new password.

  This also "logs in" the user by returning a jwt in the authorization response
  header under the "Bearer" realm, that can be used in subsequent responses.
  """
  @spec update(Plug.Conn.t, map()) :: Plug.Conn.t
  def update(conn, %{"token" => token, "password" => password}) do
    with {:ok, valid_token} <- UserTokenService.verify_token(token, :password_reset),
         {:ok, transaction} <- update_transaction(valid_token, password),
         {:ok, _status}     <- Repo.transaction(transaction),
         {:ok, jwt, _}      <- Guardian.encode_and_sign(valid_token.user, :token),
      do: render_successful_update(conn, jwt)
  end

  @spec render_successful_update(Plug.Conn.t, Types.user) :: Plug.Conn.t
  defp render_successful_update(conn, jwt) do
    conn
    |> put_status(:ok)
    |> put_resp_header("authorization", "Bearer #{jwt}")
    |> render("successful_reset.json", jwt: jwt)
  end

  @spec update_transaction(Types.user_token, String.t) :: Ecto.Multi.t
  defp update_transaction(user_token, password) do
    user_changeset = User.changeset(user_token.user, %{password: password})

    transaction = Ecto.Multi.new
    |> Ecto.Multi.update(:user_update, user_changeset)
    |> Ecto.Multi.delete(:token_delete, user_token)

    {:ok, transaction}
  end
end
