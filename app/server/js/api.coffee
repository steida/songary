goog.provide 'server.Api'

goog.require 'goog.Promise'

class server.Api

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} songsStore
    @param {server.ElasticSearch} elasticSearch
    @constructor
  ###
  constructor: (routes, songsStore, elasticSearch) ->
    @handlers = []
    api = routes.api
    client = elasticSearch.client

    @route api.song
      .put (params, body) ->
        errors = songsStore
          .instanceFromJson app.songs.Song, body
          .validatePublished()
        if errors.length
          return goog.Promise.reject errors

        # TODO: Refactor.
        new goog.Promise (resolve, reject) ->
          client.index
            index: 'songary'
            type: 'song'
            id: params.id
            body: body
          , (error, response) ->
            if error
              reject error
            else
              resolve()

      .delete (params, body) ->
        goog.Promise.resolve()

  ###*
    @param {este.Route} route
    @return {Object}
  ###
  route: (route) ->
    create = (method, handler) ->
      @handlers.push
        method: method
        path: route.path
        callback: handler
        route: route
      actions

    actions =
      delete: create.bind @, 'delete'
      get: create.bind @, 'get'
      patch: create.bind @, 'patch'
      post: create.bind @, 'post'
      put: create.bind @, 'put'

  ###*
    @param {Object} app Express instance.
    @param {function(este.Route, Object, Object, goog.Promise)} callback
  ###
  addToExpress: (app, callback) ->
    @handlers.forEach (handler) ->
      app[handler.method] handler.path, (req, res) ->
        promise = handler.callback.call @, req['params'], req['body']
        callback handler.route, req, res, promise
