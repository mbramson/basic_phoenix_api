defmodule <%= @project_name_camel_case %>Web.RegistrationControllerTest do
  use <%= @project_name_camel_case %>Web.ConnCase

  alias <%= @project_name_camel_case %>.Account

  @create_attrs %{email: "some email", name: "some name", password: "some password"}
  @invalid_attrs %{email: nil, name: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates user and sends the jwt when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @create_attrs
    assert %{"id" => _id} = json_response(conn, 201)["user"]
    assert %{"jwt" => _jwt} = json_response(conn, 201)
    auth_header = Enum.find(conn.resp_headers, fn x -> elem(x, 0) == "authorization" end)
    assert {_, "Bearer" <> _} = auth_header
  end

  test "renders a conflict when a user with given email already exists", %{conn: conn} do
    email = @create_attrs[:email]
    insert(:user, %{email: email})
    conn = post conn, registration_path(conn, :create), user: @create_attrs
    assert response = json_response(conn, 409)
  end

  test "does not create user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
