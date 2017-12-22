defmodule <%= @project_name_camel_case %>Web.Router do
  use <%= @project_name_camel_case %>Web, :router

<%= if @use_webpack? do %>
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", <%= @project_name_camel_case %>Web do
    pipe_through :browser

    get "/", PageController, :index
  end

<% end %>
  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug Guardian.Plug.EnsureResource
  end

  scope "/api", <%= @project_name_camel_case %>Web do
    pipe_through :api

    scope "/v1" do
      post "/registrations", RegistrationController, :create
      post "/sessions", SessionController, :create
      post "/password_reset", PasswordResetController, :create
      get "/password_reset", PasswordResetController, :show
      put "/password_reset", PasswordResetController, :update
    end

    scope "/v1" do
      pipe_through :api_auth

      get "/profile", ProfileController, :show
      put "/profile", ProfileController, :update
    end
  end
end
