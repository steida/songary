goog.provide 'server.Storage'

goog.require 'este.Storage'

class server.Storage extends este.Storage

  ###*
    @param {app.Routes} routes
    @param {server.ElasticSearch} elastic
    @param {app.songs.Store} songsStore
    @constructor
    @extends {este.Storage}
    @final
  ###
  constructor: (@routes, @elastic, @songsStore) ->
    super()

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
