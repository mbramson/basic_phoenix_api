defmodule <%= @project_name_camel_case %>.Web.PasswordResetControllerTest do
  use <%= @project_name_camel_case %>.Web.ConnCase

  alias <%= @project_name_camel_case %>.Repo
  alias <%= @project_name_camel_case %>.Account.{User, UserToken}

  describe "create/2" do
    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "responds and generates token if user with email exists", %{conn: conn} do
      user = insert(:user)
      conn = post conn, password_reset_path(conn, :create), email: user.email

      response = json_response(conn, 201)
      assert response["data"]["status"] == "ok"
      assert response["data"]["message"] == "Password reset email sent"
      assert Repo.get_by(UserToken, %{user_id: user.id})
    end

    test "responds with ok if no user is found with email and does not generate token", %{conn: conn} do
      conn = post conn, password_reset_path(conn, :create), email: "non-existent-email"

      response = json_response(conn, 201)
      assert response["data"]["status"] == "ok"
      assert response["data"]["message"] == "Password reset email sent"
      assert Repo.all(UserToken) == []
    end

    test "responds with ok if invalid email is supplied and does not generate token", %{conn: conn} do
      conn = post conn, password_reset_path(conn, :create), email: 123

      response = json_response(conn, 201)
      assert response["data"]["status"] == "ok"
      assert response["data"]["message"] == "Password reset email sent"
      assert Repo.all(UserToken) == []
    end

    test "responds with error if no email is supplied", %{conn: conn} do
      conn = post conn, password_reset_path(conn, :create)
      response = json_response(conn, 400)
      assert response["data"]["status"] == "error"
      assert response["data"]["message"] == "No email received"
    end
  end

  describe "show/2" do
    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "responds with ok if token is found", %{conn: conn} do
      user_token = insert(:user_token, %{type: "password_reset"})
      conn = get conn, password_reset_path(conn, :show), token: user_token.token

      response = json_response(conn, 200)
      assert response["data"]["status"] == "ok"
      assert response["data"]["message"] == "Token is valid"
    end

    test "responds with an error if the token is not found", %{conn: conn} do
      conn = get conn, password_reset_path(conn, :show), token: "non-existent-token"

      response = json_response(conn, 404)
      assert response["data"]["status"] == "error"
      assert response["data"]["message"] == "Token is invalid"
    end

    test "responds with an error if the token exists but is not the correct type", %{conn: conn} do
      user_token = insert(:user_token, %{type: "wrong_token_type"})
      conn = get conn, password_reset_path(conn, :show), token: user_token.token

      response = json_response(conn, 404)
      assert response["data"]["status"] == "error"
      assert response["data"]["message"] == "Token is invalid"
    end

    test "responds with an error if the token is expired", %{conn: conn} do
      long_ago = Ecto.DateTime.cast!({{2000, 1, 1}, {0, 0, 0}}) |> Ecto.DateTime.to_iso8601
      user_token = insert(:user_token, %{type: "password_reset", inserted_at: long_ago})
      conn = get conn, password_reset_path(conn, :show), token: user_token.token

      response = json_response(conn, 410)
      assert response["data"]["status"] == "error"
      assert response["data"]["message"] == "Token is expired"
    end
  end

  describe "update/2" do
    setup %{conn: conn} do
      {:ok, conn: put_req_header(conn, "accept", "application/json")}
    end

    test "successfully changes the password and deletes token if token is valid", %{conn: conn} do
      user_token = insert(:user_token, %{type: "password_reset"})
      conn = put conn, password_reset_path(conn, :update), token: user_token.token, password: "new_password"

      response = json_response(conn, 200)
      assert response["data"]["status"] == "ok"
      assert response["data"]["message"] == "Password successfully reset"

      updated_user = Repo.get(User, user_token.user.id)
      refute user_token.user.password_hash == updated_user.password_hash
      refute Repo.get(UserToken, user_token.id)
    end

    test "does not change the password or delete token if token is invalid", %{conn: conn} do
      conn = put conn, password_reset_path(conn, :update), token: "non-existent-token", password: "new_password"

      response = json_response(conn, 404)
      assert response["data"]["status"] == "error"
      assert response["data"]["message"] == "Token is invalid"
    end

    test "does not change the password or delete token if token is wrong type", %{conn: conn} do
      user_token = insert(:user_token, %{type: "email_confirmation"})
      conn = put conn, password_reset_path(conn, :update), token: user_token.token, password: "new_password"

      response = json_response(conn, 404)
      assert response["data"]["status"] == "error"
      assert response["data"]["message"] == "Token is invalid"
    end

    test "does not change the password or delete token if token is expired", %{conn: conn} do
      long_ago = Ecto.DateTime.cast!({{2000, 1, 1}, {0, 0, 0}}) |> Ecto.DateTime.to_iso8601
      user_token = insert(:user_token, %{type: "password_reset", inserted_at: long_ago})
      conn = put conn, password_reset_path(conn, :update), token: user_token.token, password: "new_password"

      response = json_response(conn, 410)
      assert response["data"]["status"] == "error"
      assert response["data"]["message"] == "Token is expired"

      updated_user = Repo.get(User, user_token.user.id)
      assert user_token.user.password_hash == updated_user.password_hash
      assert Repo.get(UserToken, user_token.id)
    end
  end
end
