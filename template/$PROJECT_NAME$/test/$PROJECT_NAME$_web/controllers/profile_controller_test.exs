defmodule <%= @project_name_camel_case %>Web.ProfileControllerTest do
  use <%= @project_name_camel_case %>Web.ConnCase

  alias <%= @project_name_camel_case %>.Account
  require IEx

  describe ":show" do
    test "returns correct fields of the logged in user" do
      {conn, user} = conn_with_authenticated_user()

      conn = get conn, profile_path(conn, :show)
      assert response = json_response(conn, 200)
      assert response["email"] == user.email
      assert response["name"] == user.name
    end
  end

  describe ":update" do
    test "can update the name and email of a user" do
      {conn, _user} = conn_with_authenticated_user()

      user_params = %{name: "new_name", email: "new_email"}
      conn = put conn, profile_path(conn, :update), %{"user" => user_params}
      assert response = json_response(conn, 201)
      assert response["name"] == "new_name"
      assert response["email"] == "new_email"
    end

    test "does not update the password if none is supplied" do
      {conn, user} = conn_with_authenticated_user()

      user_params = %{name: "new_name", email: "new_email"}
      put conn, profile_path(conn, :update), %{"user" => user_params}

      updated_user = Account.get_user!(user.id)
      assert updated_user.password_hash == user.password_hash
    end

    test "does not updated the password if an empty string is supplied" do
      {conn, user} = conn_with_authenticated_user()

      user_params = %{name: "new_name", email: "new_email", password: ""}
      put conn, profile_path(conn, :update), %{"user" => user_params}

      updated_user = Account.get_user!(user.id)
      assert updated_user.password_hash == user.password_hash
    end

    test "returns a 409 when the updated email is already taken" do
      {conn, _user} = conn_with_authenticated_user()
      insert(:user, %{email: "other_email"})

      user_params = %{email: "other_email"}
      conn = put conn, profile_path(conn, :update), %{"user" => user_params}

      assert json_response(conn, 409)
    end

    test "returns a 409 when the updated email of different case is already taken" do
      {conn, _user} = conn_with_authenticated_user()
      insert(:user, %{email: "other_email"})

      user_params = %{email: "OTHER_email"}
      conn = put conn, profile_path(conn, :update), %{"user" => user_params}

      assert json_response(conn, 409)
    end
  end

  describe "non-authenticated requests" do
    test "non-authenticated :show returns 403", %{conn: conn} do
      conn = get conn, profile_path(conn, :show), %{feelings: 1}
      assert text_response(conn, 403)
    end
  end
end
