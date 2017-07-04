defmodule <%= @project_name_camel_case %>.Web.SessionView do
  use <%= @project_name_camel_case %>.Web, :view
  alias <%= @project_name_camel_case %>.Web.SessionView

  def render("show.json", %{user: user, jwt: jwt}) do
    %{data: %{
        user: render_one(user, SessionView, "user.json", as: :user),
        jwt: jwt}}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email}
  end
end
