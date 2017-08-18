defmodule <%= @project_name_camel_case %>.Web.PasswordResetFallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  Contains responses specific to the PasswordResetController.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use <%= @project_name_camel_case %>.Web, :controller

  def call(conn, {:error, :no_user_with_email}), do: render_successful_token_creation(conn)
  def call(conn, {:error, :invalid_email}),      do: render_successful_token_creation(conn)

  def call(conn, {:error, :token_not_found}) do
    conn
    |> put_status(:not_found)
    |> render(<%= @project_name_camel_case %>.Web.ErrorView, :"404_invalid_token")
  end

  def call(conn, {:error, :token_expired}) do
    conn
    |> put_status(:gone)
    |> render(<%= @project_name_camel_case %>.Web.ErrorView, :"410_expired_token")
  end

  defp render_successful_token_creation(conn) do
    conn
    |> put_status(:created)
    |> render(<%= @project_name_camel_case %>.Web.PasswordResetView, :"email_sent")
  end
end
