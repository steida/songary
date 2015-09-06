var hashFile = require('hash-file');
var nconf = require('nconf');

var isProduction = process.env.NODE_ENV === 'production';

nconf.env('__');

var config = {
  assetsHashes: {
    appCss: isProduction ? hashFile.sync('build/app.css') : '',
    appJs: isProduction ? hashFile.sync('build/app.js') : ''
  },
  appLocales: ['en', 'fr'],
  defaultLocale: 'en',
  firebaseUrl: 'https://songary.firebaseio.com',
  googleAnalyticsId: 'UA-67263806-1',
  isProduction: isProduction,
  piping: {
    ignore: /(\/\.|~$|\.(css|less|sass|scss|styl))/,
    hook: true
  },
  port: process.env.PORT || 8000,
  version: require('../../package').version,
  webpackStylesExtensions: ['css', 'less', 'sass', 'scss', 'styl']
};

nconf.defaults(config);

module.exports = nconf.get();
