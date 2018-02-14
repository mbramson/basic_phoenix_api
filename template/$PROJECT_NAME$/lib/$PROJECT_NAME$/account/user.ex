defmodule <%= @project_name_camel_case %>.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias <%= @project_name_camel_case %>.Account.User


  schema "users" do
    field :email, :string
    field :name, :string

    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> downcase_email
    |> validate_length(:password, min: 8)
    |> hash_password
    |> unique_constraint(:email, message: "is already in use")
  end

  @doc """
  Changeset for use when a user is updating their own profile.

  This changeset should not allow any properties to be changed which could
  elevate the user's privileges.
  """
  def profile_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email])
    |> downcase_email
    |> validate_length(:password, min: 8)
    |> hash_password
    |> unique_constraint(:email, message: "is already in use")
  end

  @spec downcase_email(Ecto.Changeset.t) :: Ecto.Changeset.t
  defp downcase_email(%Ecto.Changeset{valid?: true, changes: %{email: email}} = changeset) do
    put_change(changeset, :email, String.downcase(email))
  end
  defp downcase_email(changeset), do: changeset

  @spec hash_password(Ecto.Changeset.t) :: Ecto.Changeset.t
  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: pass}} = changeset) do
    put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
  end
  defp hash_password(changeset), do: changeset
end
