<% MixTemplates.ignore_file_unless(@use_webpack?) %>
defmodule <%= @project_name_camel_case %>Web.LayoutView do
  use <%= @project_name_camel_case %>Web, :view
end
