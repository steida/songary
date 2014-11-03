goog.provide 'server.main'

goog.require 'server.DiContainer'

###*
  @param {Object} config
###
server.main = (config) ->

  container = new server.DiContainer

  container.configure
    resolve: server.App
    with:
      config: config
      express: require 'express'
  ,
    resolve: server.Middleware
    with:
      bodyParser: require 'body-parser'
      compression: require 'compression'
      cookieParser: require 'cookie-parser'
      cookieSecret: config['cookie']['secret']
      expressSession: require 'express-session'
      favicon: require 'serve-favicon'
      methodOverride: require 'method-override'
  ,
    resolve: server.FrontPage
    with:
      isDev: config['env']['development']
      version: config['version']
      clientData: app: version: config['version']
  ,
    resolve: server.ElasticSearch
    with:
      elasticSearch: require 'elasticsearch'
      host: config['elasticSearch']['host']
  ,
    resolve: server.Passport
    with:
      passport: require 'passport'
      Strategy: require('passport-local').Strategy

  container.resolveServerApp()

goog.exportSymbol 'server.main', server.main
