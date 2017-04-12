const webpack = require('webpack')
const path = require('path')
const copy = require('copy-webpack-plugin')

const entry = process.env.npm_lifecycle_event === 'build' ? 'prod' : 'dev';

const aliases = {
  'jQuery': 'jquery',
  '$': 'jquery',
  'window.$': 'jquery'
}


const config = {
  resolve: { alias: aliases },
  context: path.resolve(__dirname, 'src'),
  entry: "./" + entry + ".js",
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'app.js',
  //  publicPath: '/dist/',
  },
  devServer:{
    contentBase: 'dist'
  },
  plugins: [
    new webpack.NamedModulesPlugin(),
    new webpack.ProvidePlugin(aliases),
    new copy([
      { from: "./images", to: "images"}
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
        test   : /\.(jpg|png|gif|ico)?$/,
        use: [
          'url-loader'
        ]
      },

      {
        test:    /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-hot-loader!elm-webpack-loader'
        //loader:  'elm-webpack-loader?verbose=true&warn=true',
      }
    ],

    noParse: /\.elm$/
  }
}

module.exports = config
