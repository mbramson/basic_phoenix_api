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
mix gen ./basic_phoenix_api name_of_project
```

## License

> This project uses the [MIT License](https://opensource.org/licenses/MIT)

----
Created:  2017-07-04Z
