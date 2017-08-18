defmodule <%= @project_name_camel_case %>.Factory do
  use ExMachina.Ecto, repo: <%= @project_name_camel_case %>.Repo

  def user_factory do
    %<%= @project_name_camel_case %>.Account.User{
      name: sequence(:name, &"user-#{&1}"),
      email: sequence(:email, &"email-#{&1}@example.com"),
      password_hash: "password_hash"
    }
  end

  def user_token_factory do
    %<%= @project_name_camel_case %>.Account.UserToken{
      token: sequence(:token_string, &"user-token-string-#{&1}"),
      type: "password_reset",
      user: build(:user),
    }
  end
end
