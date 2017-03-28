const webpack = require('webpack')
const path = require('path')

const config = {
  context: path.resolve(__dirname, 'src'),
  entry: './app.js',
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/dist/'
  },
  plugins: [
    new webpack.NamedModulesPlugin(),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.$": "jquery",
      "window.jQuery": "jquery"
    })
  ],
 // externals: {
 //   'TweenLite': 'TweenLite'
 // },
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
        test: /\.(png|jpg)$/,
        use: [{
          loader: 'url-loader',
          options: { limit: 10000 }
        }]
      }
    
    ]
  }
}

module.exports = config
