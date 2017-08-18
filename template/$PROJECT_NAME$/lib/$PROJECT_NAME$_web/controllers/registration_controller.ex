defmodule <%= @project_name_camel_case %>Web.RegistrationController do
  use <%= @project_name_camel_case %>Web, :controller

  alias <%= @project_name_camel_case %>.Account
  alias <%= @project_name_camel_case %>.Account.User

  action_fallback <%= @project_name_camel_case %>Web.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, :token)

      conn
      |> put_status(:created)
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> render("registration.json", user: user, jwt: jwt)
    end
  end
end
