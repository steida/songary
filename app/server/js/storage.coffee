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
  promiseOf: (route, routes) ->
    switch route
      when routes.mySong, routes.editMySong
        # TODO(steida): Load song from Mongo.
        @notFound()
      else
        @ok()