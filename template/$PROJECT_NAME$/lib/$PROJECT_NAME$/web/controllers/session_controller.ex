defmodule <%= @project_name_camel_case %>.Web.SessionController do
  use <%= @project_name_camel_case %>.Web, :controller

  alias <%= @project_name_camel_case %>.Account.Session

  action_fallback <%= @project_name_camel_case %>.Web.FallbackController

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    with {:ok, user} <- Session.authenticate(session_params),
         new_conn <- Guardian.api_sign_in(conn, user) do
      jwt = Guardian.Plug.current_token(new_conn)
      {:ok, claims} = Guardian.Plug.claims(new_conn)
      exp = Map.get(claims, "exp")

      new_conn
      |> put_status(:created)
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")
      |> render("show.json", user: user, jwt: jwt, exp: exp)
    end
  end

  def delete(_conn, %{"id" => _id}) do
  end
end
