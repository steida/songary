goog.provide 'server.Storage'

goog.require 'common.Storage'

class server.Storage extends common.Storage

  ###*
    @param {app.Store} appStore
    @constructor
    @extends {common.Storage}
  ###
  constructor: (appStore) ->
    super appStore

  ###*
    @override
  ###
  promiseOf: (route, params, routes) ->
    switch route
      when routes.mySong, routes.editMySong
        @notFound()
      else
        @ok()
