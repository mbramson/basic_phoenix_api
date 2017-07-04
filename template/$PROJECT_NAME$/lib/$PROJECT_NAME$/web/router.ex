defmodule <%= @project_name_camel_case %>.Web.Router do
  use <%= @project_name_camel_case %>.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", <%= @project_name_camel_case %>.Web do
    pipe_through :api

    scope "/v1" do
      post "/registrations", RegistrationController, :create
      post "/sessions", SessionController, :create
    end

    scope "/v1" do
      pipe_through :api_auth

    end
  end
end
