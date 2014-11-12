goog.provide 'server.Storage'

goog.require 'goog.Promise'
goog.require 'goog.net.HttpStatus'

class server.Storage

  ###*
    @param {app.Routes} routes
    @param {server.ElasticSearch} elastic
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (@routes, @elastic, @songsStore) ->

  ok: ->
    goog.Promise.resolve goog.net.HttpStatus.OK

  notFound: ->
    goog.Promise.resolve goog.net.HttpStatus.NOT_FOUND

  ###*
    @param {este.Route} route
    @param {Object} params
    @return {!goog.Promise}
  ###
  load: (route, params) ->
    switch route
      when @routes.about, @routes.home, @routes.newSong
        @ok()
      when @routes.song
        @elastic.getSongsByUrl params.urlArtist, params.urlName
          .then (songs) =>
            return @notFound() if !songs.length
            @songsStore.fromJson songsByUrl: songs
      when @routes.songs
        @ok()
      when @routes.recentlyUpdatedSongs
        @elastic.getRecentlyUpdatedSongs()
          .then (songs) =>
            @songsStore.fromJson recentlyUpdatedSongs: songs
      else
        @notFound()
