defmodule <%= @project_name_camel_case %>.Repo.Migrations.Create<%= @project_name_camel_case %>.Account.UserToken do
  use Ecto.Migration

  def change do
    create table(:user_tokens) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :token, :string, null: false
      add :type, :string, null: false

      timestamps()
    end

    create unique_index(:user_tokens, [:token])
  end
end
