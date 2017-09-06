defmodule <%= @project_name_camel_case %>.Repo.Migrations.Create<%= @project_name_camel_case %>.Account.User do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
