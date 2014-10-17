goog.provide 'server.Api'

goog.require 'goog.Promise'
goog.require 'server.songs'

class server.Api

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} songsStore
    @param {server.ElasticSearch} elastic
    @constructor
  ###
  constructor: (routes, songsStore, elastic) ->
    api = routes.api
    @handlers = []

    # Publish/Unpublish.
    @route api.songs.id
      .put (req) ->
        errors = new app.songs.Song req.body
          .validatePublished()
        if errors.length
          return goog.Promise.reject errors
        server.songs.toPublishedJson req.body
          .then (song) ->
            elastic.index index: 'songary', type: 'song', id: req.params.id, body:
              song

      .delete (req) ->
        elastic.delete index: 'songary', type: 'song', id: req.params.id

    @route api.songs.recentlyUpdated
      .get ->
        elastic.getRecentlyUpdatedSongs()

    @route api.songs.byUrl
      .get (req) ->
        elastic.getSongsByUrl req.params.urlArtist, req.params.urlName

    @route api.songs.search
      .get (req) ->
        elastic.searchSongsByQuery req.query.query

    @route api.clientErrors
      .post (req) ->
        elastic.index index: 'songary', type: 'clienterror', body:
          # Does not work for some reason, but line is specified in trace.
          # line: req.body['line']
          action: req.query.action
          error: req.query.error
          reportedAt: new Date().toISOString()
          script: req.query.script
          trace: req.body.trace
          user: req.query.user
          userAgent: req.headers['user-agent']

  ###*
    @param {este.Route} route
    @return {Object}
  ###
  route: (route) ->
    create = (method, handler) ->
      @handlers.push
        callback: handler
        method: method
        path: route.path
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
        promise = handler.callback.call @, req
        callback handler.route, req, res, promise
