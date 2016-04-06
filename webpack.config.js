module.exports = {
    entry:  './app/assets/javascripts/main.js',
    output: {
        path:     './app/assets/javascripts',
        filename: 'bundle.js',
    },
    watch: true,
    watchOptions: {
      aggregateTimeout:300,
      poll: 5
    },
    module: {
        loaders: [
            {
              test:   /\.js/,
              loader: 'babel',
              exclude: /node_modules/,
              include: __dirname + '/app/assets/javascripts',
              query: {
                presets: ['react', 'es2015']
              }
            },
            {
              test: /\.(css|scss)$/,
              loaders: ['style', 'css', 'sass'],
              exclude: /node_modules/
            }
        ],
    }
};
