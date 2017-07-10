defmodule <%= @project_name_camel_case %>.Web.SessionControllerTest do
  use <%= @project_name_camel_case %>.Web.ConnCase

  alias <%= @project_name_camel_case %>.Account

  @create_attrs %{name: "some name", email: "some email", password: "some password"}
  @login_attrs %{email: "some email", password: "some password"}
  @invalid_attrs %{email: nil, password: nil}

  def fixture(:user) do
    {:ok, user} = Account.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "logs the user in and sends the jwt when data is valid", %{conn: conn} do
    fixture(:user)
    conn = post conn, session_path(conn, :create), session: @login_attrs
    assert %{"id" => _id} = json_response(conn, 201)["data"]["user"]
    assert %{"jwt" => _jwt} = json_response(conn, 201)["data"]
    auth_header = Enum.find(conn.resp_headers, fn x -> elem(x, 0) == "authorization" end)
    assert {_, "Bearer" <> _} = auth_header
  end

  test "does not log the user in and renders a 401 unauthorized error when data is invalid", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: @invalid_attrs
    assert json_response(conn, 401)["errors"] != %{}
  end

  test "does not log the user in and renders a 401 unauthorized error when data is missing", %{conn: conn} do
    conn = post conn, session_path(conn, :create), session: %{}
    assert json_response(conn, 401)["errors"] != %{}
  end
end
