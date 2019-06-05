const path = require('path')

module.exports = {
  mode: 'production',
  entry: {
    specs: './src/specs.coffee',
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
}
