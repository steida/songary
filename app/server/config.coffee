fs = require 'fs'
path = require 'path'

# TODO: Change before release, then use env vars like process.env.COOKIE_SECRET.
elasticSearchHost = 'http://101e695cd8f4b826000.qbox.io'
cookieSecret = 'songary'

currentEnv = process.env.NODE_ENV || 'development'
port = process.env.PORT || 8000

module.exports =
  cookie: secret: cookieSecret
  env:
    development: currentEnv == 'development'
    production: currentEnv == 'production'
  # TODO: Don't use self-signed certificates.
  # httpsOptions:
  #   key: fs.readFileSync __dirname + '/key.pem'
  #   cert: fs.readFileSync __dirname + '/cert.pem'
  server:
    port: port
    url: if currentEnv == 'development'
      "http://localhost:#{port}/"
    else
      "http://#{process.env.SUBDOMAIN}.jit.su/"
  elasticSearch: host: elasticSearchHost
  version: require('../../package.json')['version']
