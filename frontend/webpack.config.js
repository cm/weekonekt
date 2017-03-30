const webpack = require('webpack')
const path = require('path')
const copy = require('copy-webpack-plugin')

const aliases = { 
  'jQuery': 'jquery',
  '$': 'jquery',
  'window.$': 'jquery'
}


const config = {
  externals: {
     'TweenLite': 'TweenLite'
  },
  context: path.resolve(__dirname, 'src'),
  entry: './app.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'app.js',
    publicPath: '/dist/',
  },
  plugins: [
    new webpack.NamedModulesPlugin(),
    new webpack.ProvidePlugin(aliases),
    new copy([
      { from: "img/home/slider", to: "img/slider"}
    ])
  ],
  module: {
    rules: [
      {
        test: /\.js$/,
        include: path.resolve(__dirname, 'src'),
        use: [{
          loader: 'babel-loader',
          options: {
            presets: [
              ['es2015', { modules: false }]
            ]
          }
        }]
      },
      {
        test: /\.scss$/,
        use: [
          'style-loader',
          'css-loader',
          'sass-loader'
        ]
      },
      {
        test: /\.css$/,
        use: [
          'style-loader',
          'css-loader',
        ]
      },
      {
        test   : /\.(ttf|eot|svg|woff(2)?)(\?[a-z0-9=&.]+)?$/,
        use: [
          'url-loader'
        ]
      },
      {
        test   : /\.(jpg|png|gif)?$/,
        use: [
          'url-loader'
        ]
      },

      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader:  'elm-webpack-loader?verbose=true&warn=true',
      }
    ],

    noParse: /\.elm$/
  }
}

module.exports = config
