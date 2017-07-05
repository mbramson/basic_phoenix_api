defmodule <%= @project_name_camel_case %>.Web.SessionController do
  use <%= @project_name_camel_case %>.Web, :controller

  alias <%= @project_name_camel_case %>.Account.Session

  action_fallback <%= @project_name_camel_case %>.Web.FallbackController

  plug :scrub_params, "session" when action in [:create]

  def create(conn, %{"session" => session_params}) do
    with {:ok, user} <- Session.authenticate(session_params),
         {:ok, jwt, _} <- Guardian.encode_and_sign(user, :token) do
      conn
      |> put_status(:created)
      |> put_resp_header("authorization", "Bearer #{jwt}")
      |> render("show.json", jwt: jwt, user: user)
    end
  end

  def delete(_conn, %{"id" => _id}) do
  end
end
