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
      compression: require 'compression'
      favicon: require 'static-favicon'
      bodyParser: require 'body-parser'
      methodOverride: require 'method-override'
  ,
    resolve: app.Firebase
    with: firebase: require 'firebase'
  ,
    resolve: server.FrontPage
    with:
      isDev: config['env']['development']
      version: config['version']
      clientData:
        app:
          version: config['version']

  container.resolveServerApp()

goog.exportSymbol 'server.main', server.main
