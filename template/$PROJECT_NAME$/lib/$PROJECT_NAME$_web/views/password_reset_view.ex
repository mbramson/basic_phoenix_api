defmodule <%= @project_name_camel_case %>Web.PasswordResetView do
  use <%= @project_name_camel_case %>Web, :view

  def render("email_sent.json", _) do
    %{data: %{
        status: "ok",
        message: "Password reset email sent"}}
  end

  def render("no_email_received.json", _) do
    %{data: %{
        status: "error",
        message: "No email received"}}
  end

  def render("valid_token.json", _) do
    %{data: %{
        status: "ok",
        message: "Token is valid"}}
  end

  def render("successful_reset.json", %{jwt: jwt}) do
    %{data: %{
        status: "ok",
        message: "Password successfully reset",
        jwt: jwt}}
  end
end
