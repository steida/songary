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
      isDev: config['env']['development']
      port: config['server']['port']
      express: require 'express'
  ,
    resolve: server.FrontPage
    with:
      isDev: config['env']['development']
      version: config['version']
      clientData: {}
  ,
    resolve: server.Middleware
    with:
      compression: require 'compression'
      favicon: require 'static-favicon'
      bodyParser: require 'body-parser'
      methodOverride: require 'method-override'

  container.resolveServerApp()

goog.exportSymbol 'server.main', server.main