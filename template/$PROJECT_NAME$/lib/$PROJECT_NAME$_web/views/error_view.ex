defmodule <%= @project_name_camel_case %>Web.ErrorView do
  use <%= @project_name_camel_case %>Web, :view

  def render("401_invalid_credentials.json", _assigns) do
    %{errors: %{detail: "Invalid credentials"}}
  end

  def render("403.json", _assigns) do
    %{errors: %{detail: "Action is forbidden"}}
  end

  def render("404.json", _assigns) do
    %{errors: %{detail: "Page not found"}}
  end

  def render("404_invalid_token.json", _assigns) do
    %{data: %{
        status: "error",
        message: "Token is invalid"}}
  end

  def render("410_expired_token.json", _assigns) do
    %{data: %{
        status: "error",
        message: "Token is expired"}}
  end

  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.json", assigns
  end
end
