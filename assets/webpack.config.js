const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const TerserPlugin = require('terser-webpack-plugin');
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = (_env, options) => {
  const devMode = options.mode !== 'production';

  return {
    mode: options.mode || 'development',

    optimization: {
      minimizer: [
        new TerserPlugin({parallel: true}),
        new OptimizeCSSAssetsPlugin({})
      ]
    },
    entry: {
      'app': glob.sync('./vendor/**/*.js').concat(['./js/app.ts'])
    },
    output: {
      filename: '[name].js',
      path: path.resolve(__dirname, '../priv/static/js'),
      publicPath: '/js/'
    },
    devtool: devMode ? 'eval-cheap-module-source-map' : undefined,

    module: {
      rules: [
        {
          test: /\.tsx?$/,
          use: 'ts-loader',
          exclude: /node_modules/,
        },

        {
          test: /\.css$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            {
              loader: "postcss-loader",
              options: {
                postcssOptions: {
                  plugins: [
                    [
                      "postcss-preset-env",
                      {
                        // Options
                      },
                    ],
                  ],
                },
              },
            }
          ],
        }
      ]
    },

    resolve: {
      extensions: [".ts", ".tsx", ".js"],
      alias: {
        react: path.resolve(__dirname, './node_modules/react'),
        'react-dom': path.resolve(__dirname, './node_modules/react-dom')
      }
    },

    plugins: [
      new MiniCssExtractPlugin({filename: '../css/app.css'}),
      new CopyWebpackPlugin({
        patterns: [
          {from: "static/", to: "../"}
        ]
      })
    ]
  }
};
