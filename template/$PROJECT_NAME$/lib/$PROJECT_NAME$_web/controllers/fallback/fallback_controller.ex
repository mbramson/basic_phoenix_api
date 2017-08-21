defmodule <%= @project_name_camel_case %>Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use <%= @project_name_camel_case %>Web, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(<%= @project_name_camel_case %>Web.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(<%= @project_name_camel_case %>Web.ErrorView, :"404")
  end

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> render(<%= @project_name_camel_case %>Web.ErrorView, :"401_invalid_credentials")
  end
end
