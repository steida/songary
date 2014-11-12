goog.provide 'app.Storage'

class app.Storage

  ###*

    @param {app.Routes} routes
    @param {app.Xhr} xhr
    @constructor
  ###
  constructor: (@routes, @xhr) ->

  ###*
    @param {Object} params
    @return {!goog.Promise}
  ###
  getSong: (params) ->
    @xhr.get @routes.api.songs.byUrl.url params

  ###*
    @return {!goog.Promise}
  ###
  getRecentlyUpdatedSongs: ->
    @xhr.get @routes.api.songs.recentlyUpdated.url()

  ###*
    @param {string} query
    @return {!goog.Promise}
  ###
  searchSongByQuery: (query) ->
    @xhr.get @routes.api.songs.search.url null, query: query
