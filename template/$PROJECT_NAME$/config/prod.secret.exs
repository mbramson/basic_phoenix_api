use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :<%= @project_name %>, <%= @project_name_camel_case %>.Web.Endpoint,
  secret_key_base: <%= :crypto.strong_rand_bytes(64) |> Base.encode64 |> binary_part(0, 64) %>

# Configure your database
config :<%= @project_name %>, <%= @project_name_camel_case %>.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "<%= @project_name %>_prod",
  pool_size: 15
