defmodule <%= @project_name_camel_case %>.Types do
  @moduledoc false

  # Ecto Schema Types
  @type user :: <%= @project_name_camel_case %>.Account.User
  @type user_token :: <%= @project_name_camel_case %>.Account.UserToken
end
