const { webpackConfig, merge } = require('shakapacker')

// See the shakacode/shakapacker README and docs directory for advice on customizing your webpackConfig.

const customConfig = {
  resolve: {
    extensions: ['.css', '.scss']
  },
  output: {
    // Makes exports from entry packs available to global scope, e.g.
    // Packs.application.myFunction
    library: ['Packs', '[name]'],
    libraryTarget: 'var'
  }
}

const sassLoaderConfig = {
  module: {
    rules: [
      {
        test: /\.s[ac]ss$/i,
        use: ["sass-loader"],
      },
    ],
  },
}

const experiments = {
  experiments: {
    topLevelAwait: true
  }
}

module.exports = merge(webpackConfig, customConfig, sassLoaderConfig, experiments)
