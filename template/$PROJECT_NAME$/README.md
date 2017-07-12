# <%= @project_name_camel_case %>

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## Basic API Endpoint Features

Out of the box this phoenix template contains registration and session JSON endpoints.

#### Registration Endpoint
- POST to /api/v1/registrations
  - Example POST:
```
{
  "user": {
    "email": "matt@example.com",
    "name": "matt",
    "password": "secret_password"
  }
}
```
  - Creates the user and renders the following JSON:
```
{
  "data": {
    "user": {
      "id": 1,
       "name": "matt",
       "email": "matt@example.com"
    },
    "jwt": {
      "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjMiLCJleHAiOjE1MDE3ODk2NjQsImlhdCI6MTQ5OTE5NzY2NCwiaXNzIjoiUGFpcm1vdHJvbiIsImp0aSI6IjNkZmM5Yzk4LThiY2MtNDVjNy1hNmU2LTZhNDBlY2JmOTYyOCIsInBlbSI6e30sInN1YiI6IlVzZXI6MyIsInR5cCI6InRva2VuIn0.AOrdflQzn5wCdzJLOFwjcb5Zcxt_8xlYoH7nEXB-Sl3DQ6twvRGhD2r0NuVHDXz4wOglU7BizFGB3e3l0jJjw_TOAJYl-YJo4NAR3GtPRW7g6bSLJYO5AfTT2wx1ApTv3IsIhhbi57QdVerbHimd-LM1EMHPubqhkYyvdVQQbwFD1SYn"
    }
  }
}
```
  - The JWT will also be present in the Authorization header as "Bearer <jwt_token>"

#### Session Endpoint
- POST to /api/v1/sessions
  - Example POST:
```
{
  "session": {
    "email": "matt@example.com",
    "password": "secret_password"
  }
}
```
  - Checks that the password is correct. If so, it renders the following JSON:
```
{
  "data": {
    "user": {
      "id": 1,
       "name": "matt",
       "email": "matt@example.com"
    },
    "jwt": {
      "eyJhbGciOiJFUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJVc2VyOjMiLCJleHAiOjE1MDE3ODk2NjQsImlhdCI6MTQ5OTE5NzY2NCwiaXNzIjoiUGFpcm1vdHJvbiIsImp0aSI6IjNkZmM5Yzk4LThiY2MtNDVjNy1hNmU2LTZhNDBlY2JmOTYyOCIsInBlbSI6e30sInN1YiI6IlVzZXI6MyIsInR5cCI6InRva2VuIn0.AOrdflQzn5wCdzJLOFwjcb5Zcxt_8xlYoH7nEXB-Sl3DQ6twvRGhD2r0NuVHDXz4wOglU7BizFGB3e3l0jJjw_TOAJYl-YJo4NAR3GtPRW7g6bSLJYO5AfTT2wx1ApTv3IsIhhbi57QdVerbHimd-LM1EMHPubqhkYyvdVQQbwFD1SYn"
    }
  }
}
```
  - The JWT will also be present in the Authorization header as "Bearer <jwt_token>"
  - If an incorrect email/password confirmation is sent to the sessions endpoint, the following JSON will be rendered:
```
{
  "errors": {
    "detail": "Invalid credentials"
  }
}
```

To implement a route that uses authorization simply pipe through the :api_auth
plug in the router. Ensure that any HTTP request made to an authorized route
contains the JWT in the "Bearer" realm of the authorization header.

## Environment Variables

* SECRET_KEY_BASE - Used to generate session cookies. To generate your own:
```elixir
:crypto.strong_rand_bytes(64) |> Base.encode64 |> binary_part(0, 64)
```
<%= if @is_heroku? do %>
* DATABASE_URL - The URL to your postgres database instance on Heroku
<% else %>
* PG_USER - The postgres username
* PG_PASSWORD - THe postgres password
<% end %>

### JWT Key Configuration

<%= @project_name_camel_case %> uses the ES512 algorithm to generate JSON Web Tokens. You will need to generate a key and set the appropriate environment variables.

To generate a key do the following from the root pairmotron directory:

```elixir
iex -S mix

iex> JOSE.JWK.generate_key({:ec, "P-521"}) |> JOSE.JWK.to_map
{%{kty: :jose_jwk_kty_ec},
 %{"crv" => "P-521",
   "d" => "Ae-wdbGhjfpxapevgJDAxaiGHmKYoyWnYDLeAb9jALSBNBzkyelSL-FUHcdFw1B7V2FvPy3YaHEkrVqwPwBwNvLP",
   "kty" => "EC",
   "x" => "AWFw34kJJaT8Lwew8IG4LcDDr8sMcURn4PhUWMBiMW5vGGonteVvZQAVdW652GFOY9z1nlhymKYXBwNy3PHlz9Z_",
   "y" => "APLY5Rww4oI1fhUI7JrIkmHPymzgpGOKsNXHhxoMJDycdoQPWfaimoOX-afOHoJiGWwh2m_EbTSC-4lC4Cz0uzPk"}}
```

And then set the following environment variables:
* GUARDIAN_JWK_ES512_D - The "d" value of the key generated above.
* GUARDIAN_JWK_ES512_X - The "x" value of the key generated above.
* GUARDIAN_JWK_ES512_Y - The "y" value of the key generated above.
