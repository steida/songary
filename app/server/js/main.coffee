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
      express: require 'express'
      isDev: config['env']['development']
      port: config['server']['port']
  ,
    resolve: app.Firebase
    with:
      firebase: require 'firebase'
  ,
    resolve: server.FrontPage
    with:
      isDev: config['env']['development']
      version: config['version']
      clientData:
        app:
          version: config['version']
  ,
    resolve: server.ElasticSearch
    with:
      elasticSearch: require 'elasticsearch'
      host: config['elasticSearch']['host']

  container.resolveServerApp()

goog.exportSymbol 'server.main', server.main
