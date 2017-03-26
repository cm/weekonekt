const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  context: path.resolve(__dirname, './src'),
  entry: {
    app: './js/dev.js',
  },
  output: {
    path: path.resolve(__dirname, '../static'),
    filename: 'bundle.js',
  },

  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: [/node_modules/],
        use: [{
          loader: 'babel-loader',
          options: { presets: ['es2015'] }
        }],
      },

      {
        test: /\.css$/,
        use: [
          'style-loader', 
          'css-loader'
        ],
      },

      {
        test: /\.(sass|scss)$/,
        use: [
          'style-loader',
          'css-loader',
          'sass-loader',
        ]
      },

      {
        test: /\.(jpe?g|gif|png|svg)$/i,
        loader: 'file-loader',
      },

      {
        test: /\.(eot|svg|ttf|woff|woff2)$/,
        loader: 'file-loader'
      }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'html/index.html',
      inject:   'body',
      filename: 'index.html'
    }),

    new CopyWebpackPlugin([
      { from: 'img', to: 'img' }
    ])
  ]
}
