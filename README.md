# BasicPhoenixApi

This is a mix template for creating a basic phoenix API with working registration and session endpoints (and very little else). Its only non-default dependencies are Comeonin for password hashing and Guardian for JWT generation and verification.

This template was created by roughly following this guide: http://www.schmitty.me/phoenix-1-3-and-webpack-2-0/.

You will need to install the following mix dependencies globally to use this template:

```
$ mix archive.install hex mix_templates
$ mix archive.install hex mix_generator
```

To use this, clone it and navigate to the parent directory of this project. Then:

```
mix gen ./basic_phoenix_api name_of_project [options]
```

## Options

Several options exist to help set up your project with some extra configuration:

### travis_ci

Use this option when you'd like your project to be configured to work with [Travis CI](https://travis-ci.org). When set, this will generate a `.travis.yml` file that is configured to use Elixir 1.4.5 and OTP 20.0.

#### Usage

```
mix gen ./basic_phoenix_api name_of_project --travis_ci
```

### heroku

Use this option when you'd like your project to be configured to work with [Heroku](https://heroku.com). When set, this will generate several files:
* `Procfile` - Configured to run your migrations whenever you make a new release and start your server
* `elixir_buildpack.config` - Configured to tell Heroku that you are running on Elixir 1.4.5

#### Usage

```
mix gen ./basic_phoenix_api name_of_project --heroku
```

## License

> This project uses the [MIT License](https://opensource.org/licenses/MIT)

----
Created:  2017-07-04Z
