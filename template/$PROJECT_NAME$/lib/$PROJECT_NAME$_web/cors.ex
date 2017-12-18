defmodule <%= @project_name_camel_case %>Web.CORS do
  use Corsica.Router,
    origins: ["http://localhost:3000", ~r{^https?://(.*\.?)\.com$}],
    allow_credentials: true,
    allow_headers: ["content-type", "authorization"],
    log: [rejected: :debug, invalid: :debug, accepted: :debug],
    max_age: 600

  resource "/*", origins: "*"
end
