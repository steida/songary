fs = require 'fs'
path = require 'path'

currentEnv = process.env.NODE_ENV || 'development'
port = process.env.PORT || 8000

module.exports =
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
  elasticSearch:
    # TODO: Use external configuration.
    host: 'http://101e695cd8f4b826000.qbox.io'
  version: require('../../package.json')['version']
