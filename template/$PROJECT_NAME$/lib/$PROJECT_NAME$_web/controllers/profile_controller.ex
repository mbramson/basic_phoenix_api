defmodule <%= @project_name_camel_case %>Web.ProfileController do
  use <%= @project_name_camel_case %>Web, :controller

  action_fallback <%= @project_name_camel_case %>Web.FallbackController

  alias <%= @project_name_camel_case %>.Account

  def show(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    render(conn, "show.json", user: current_user)
  end

  def update(conn, %{"user" => user_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    with {:ok, updated_user} <- Account.update_user_profile(current_user, user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: updated_user)
    end
  end
end
