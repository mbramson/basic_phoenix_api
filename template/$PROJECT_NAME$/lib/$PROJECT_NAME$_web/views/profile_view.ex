defmodule <%= @project_name_camel_case %>Web.ProfileView do
  use <%= @project_name_camel_case %>Web, :view

  alias <%= @project_name_camel_case %>.Account.User

  def render("show.json", %{user: %User{email: email, name: name}}) do
    %{name: name, email: email}
  end
end
