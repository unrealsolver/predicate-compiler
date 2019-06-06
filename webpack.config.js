const path = require('path')
const UgifyJsPlugin = require('uglifyjs-webpack-plugin')

module.exports = {
  mode: 'production',
  entry: {
    main: './src/main.coffee',
  },
  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name]-dist.js',
  },
  module: {
    rules: [{
      test: /\.coffee$/,
      use: ['coffee-loader'],
    }],
  },
  resolve: {
    modules: [path.resolve(__dirname, './src'), 'node_modules'],
    extensions: ['.coffee'],
  },
  externals: {
    underscore: {
      commonjs: 'underscore',
      amd: 'underscore',
      root: '_',
    },
  },
  optimization: {
    minimize: true,
  },
}
