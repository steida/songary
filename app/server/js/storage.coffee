goog.provide 'server.Storage'

goog.require 'este.labs.storage.Base'

class server.Storage extends este.labs.storage.Base

  ###*
    @constructor
    @extends {este.labs.storage.Base}
  ###
  constructor: ->

  ###*
    @override
  ###
  load: (route, routes) ->
    super route, routes