const path = require('path')
const ExtractTextPlugin = require('extract-text-webpack-plugin')

module.exports = function (env) {
  return {
    entry: [
      'webpack-dev-server/client?http://localhost:8080',
      'webpack/hot/only-dev-server',
      './index.js'
    ],
    output: {
      path: path.resolve(__dirname, 'build'),
      filename: 'bundle.js'
    },
    module: {
      rules: [
        {
          test: /\.elm/,
          exclude: [/elm-stuff/, /node_modules/],
          use: [ 'elm-webpack-loader' ]
        },
        {
          test: /\.scss/,
          loader: ExtractTextPlugin.extract('css-loader!sass-loader')
        }
      ]
    },
    devServer: {
      contentBase: path.join(__dirname, "build"),
      inline: true,
      compress: true,
      port: 8080
    },
    plugins: [
      new ExtractTextPlugin({ filename: 'bundle.css', disable: false, allChunks: true })
    ]
  }
}
