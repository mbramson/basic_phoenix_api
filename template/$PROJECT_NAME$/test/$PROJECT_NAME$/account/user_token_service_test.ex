defmodule <%= @project_name_camel_case %>.Account.UserTokenServiceTest do
  use <%= @project_name_camel_case %>.DataCase

  alias <%= @project_name_camel_case %>.Account.UserTokenService

  describe "generate_token/2" do
    test "returns a token if the email is associated with an email" do
      user = insert(:user)
      {:ok, token} = UserTokenService.generate_token(user.email, :email_confirmation)
      assert token.user.id == user.id
    end

    test "returns error tuple when no user exists with that email" do
      result = UserTokenService.generate_token("non-existent-email", :email_confirmation)
      assert result == {:error, :no_user_with_email}
    end

    test "returns an error tuple when an invalid argument is sent for email" do
      assert {:error, :invalid_email} == UserTokenService.generate_token(123, :email_confirmation)
    end
  end

  describe "verify_token/2" do
    test "returns tuple containing token if it exists" do
      user_token = insert(:user_token, %{type: "email_confirmation"})
      {:ok, resulting_token} = UserTokenService.verify_token(user_token.token, :email_confirmation)
      assert resulting_token.id == user_token.id
      assert resulting_token.user.id == user_token.user.id
    end

    test "returns error tuple if token does not exist" do
      result = UserTokenService.verify_token("non-existent-token", :email_confirmation)
      assert {:error, :token_not_found} == result
    end

    test "returns error tuple if token exists but is wrong type" do
      user_token = insert(:user_token, %{type: "email_confirmation"})
      result = UserTokenService.verify_token(user_token.token, :wrong_type)
      assert {:error, :token_not_found} == result
    end

    test "returns an error tuple if token exists but has expired" do
      long_ago = Ecto.DateTime.cast!({{2000, 1, 1}, {0, 0, 0}}) |> Ecto.DateTime.to_iso8601
      user_token = insert(:user_token, %{type: "email_confirmation", inserted_at: long_ago})
      result = UserTokenService.verify_token(user_token.token, :email_confirmation)
      assert {:error, :token_expired} = result
    end
  end
end

