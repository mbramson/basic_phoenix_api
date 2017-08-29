<% MixTemplates.ignore_file_unless(@use_webpack?) %>
const path = require('path');
const ExtractTextPlugin = require("extract-text-webpack-plugin");

module.exports = {
  entry: ["./js/app.js", "./css/app.css"],
  output: {
    path: path.resolve(__dirname, '../priv/static/js'),
    filename: "app.js"
  },
  module: {
    rules: [
      {
        test: /\.css$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: "css-loader"
        })
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("../css/app.css")
  ]
};
