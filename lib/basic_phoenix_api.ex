defmodule BasicPhoenixApi do

  @moduledoc File.read!(Path.join([__DIR__, "../README.md"]))

  use MixTemplates,
    name:       :basic_phoenix_api,
    short_desc: "Template for a basic phoenix 1.3.0 JSON api with minimal user functionality",
    source_dir: "../template",
    options: [
      heroku: [ to: :is_heroku?, default: false ],
      travis_ci: [ to: :is_travis?, default: false ],
      webpack: [ to: :use_webpack?, default: false ],
    ]

end
