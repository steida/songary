goog.provide 'server.Storage'

goog.require 'este.labs.Storage'
goog.require 'goog.net.HttpStatus'

class server.Storage extends este.labs.Storage

  ###*
    @param {app.Store} appStore
    @constructor
    @extends {este.labs.Storage}
  ###
  constructor: (@appStore) ->

  ###*
    @override
  ###
  load: (route, routes) ->
    @promiseOf route, routes
      .then @setHttpStatus.bind @
      .thenCatch @setHttpStatus.bind @

  setHttpStatus: (httpStatus) ->
    @appStore.httpStatus = httpStatus

  promiseOf: (route, routes) ->
    switch route
      when routes.mySong, routes.editMySong
        # TODO(steida): Load song from Mongo.
        goog.Promise.reject goog.net.HttpStatus.NOT_FOUND
      else
        goog.Promise.resolve goog.net.HttpStatus.OK