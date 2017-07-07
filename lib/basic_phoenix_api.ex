defmodule BasicPhoenixApi do

  @moduledoc File.read!(Path.join([__DIR__, "../README.md"]))

  use MixTemplates,
    name:       :basic_phoenix_api,
    short_desc: "Template for ....",
    source_dir: "../template",
    options: [
      heroku: [ to: :is_heroku?, default: false ]
    ]

end
