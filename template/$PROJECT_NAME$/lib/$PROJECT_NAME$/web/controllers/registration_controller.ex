defmodule <%= @project_name_camel_case %>.Web.RegistrationController do
  use <%= @project_name_camel_case %>.Web, :controller

  alias <%= @project_name_camel_case %>.Account
  alias <%= @project_name_camel_case %>.Account.User

  action_fallback <%= @project_name_camel_case %>.Web.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params),
         new_conn <- Guardian.Plug.api_sign_in(conn, user) do
      jwt = Guardian.Plug.current_token(new_conn)
      {:ok, claims} = Guardian.Plug.claims(new_conn)
      exp = Map.get(claims, "exp")

      new_conn
      |> put_status(:created)
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")
      |> render("registration.json", user: user, jwt: jwt, exp: exp)
    end
  end
end
