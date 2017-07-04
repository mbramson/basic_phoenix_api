defmodule <%= @project_name_camel_case %>.AccountTest do
  use <%= @project_name_camel_case %>.DataCase

  alias <%= @project_name_camel_case %>.Account

  describe "users" do
    alias <%= @project_name_camel_case %>.Account.User

    @valid_attrs %{email: "some email", name: "some name", password: "some password"}
    @update_attrs %{email: "some updated email", name: "some updated name", password: "some updated password"}
    @invalid_attrs %{email: nil, name: nil, password_hash: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Account.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert [returned_user] = Account.list_users()
      assert user.id == returned_user.id
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert %User{id: id} = Account.get_user!(user.id)
      assert id == user.id
    end

    test "get_user_by_email/1 returns the user with that email" do
      user = user_fixture()
      assert %User{id: id} = Account.get_user_by_email(String.upcase(user.email))
      assert id == user.id
    end

    test "get_user_by_email/1 returns the user with that email if the given email is uppercase" do
      user = user_fixture()
      assert %User{id: id} = Account.get_user_by_email(String.upcase(user.email))
      assert id == user.id
    end

    test "get_user_by_email/1 returns nil when given nil" do
      assert Account.get_user_by_email(nil) == nil
    end

    test "get_user_by_email/1 returns nil when given non-existent email" do
      assert Account.get_user_by_email("what email") == nil
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Account.create_user(@valid_attrs)
      assert user.email == "some email"
      assert user.name == "some name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, user} = Account.update_user(user, @update_attrs)
      assert %User{} = user
      assert user.email == "some updated email"
      assert user.name == "some updated name"
    end

    test "update_user/2 with a password updates the password" do
      user = user_fixture()
      assert {:ok, updated_user} = Account.update_user(user, %{password: "new_password"} )
      refute user.password_hash == updated_user.password_hash
    end

    test "update_user/2 without a password update does not update the password" do
      user = user_fixture()
      assert {:ok, updated_user} = Account.update_user(user, %{email: "new_email@example.com"} )
      assert user.password_hash == updated_user.password_hash
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      updated_user = Account.get_user!(user.id)
      assert user.id == updated_user.id
      assert user.email == updated_user.email
      assert user.name == updated_user.name
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end
end
