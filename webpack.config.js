const path = require('path')

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
        }
      ]
    },
    devServer: {
      contentBase: path.join(__dirname, "build"),
      // hot: true,
      inline: true,
      compress: true,
      port: 8080
    }
  }
}
