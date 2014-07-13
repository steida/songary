goog.provide 'common.Storage'

goog.require 'este.labs.Storage'
goog.require 'goog.net.HttpStatus'

class common.Storage extends este.labs.Storage

  ###*
    TODO(steida): Consider move into library.
    @param {app.Store} appStore
    @constructor
    @extends {este.labs.Storage}
  ###
  constructor: (@appStore) ->
    super()

  ###*
    @override
  ###
  load: (route, routes) ->
    @promiseOf route, routes
      .then @setHttpStatus.bind @
      .thenCatch @setHttpStatus.bind @

  ###*
    @param {este.Route} route
    @param {este.Routes} routes
    @return {!goog.Promise}
    @protected
  ###
  promiseOf: goog.abstractMethod

  ###* @protected ###
  ok: ->
    goog.Promise.resolve goog.net.HttpStatus.OK

  ###* @protected ###
  notFound: ->
    goog.Promise.reject goog.net.HttpStatus.NOT_FOUND

  ###* @protected ###
  setHttpStatus: (httpStatus) ->
    @appStore.httpStatus = httpStatus