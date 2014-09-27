goog.provide 'server.Storage'

goog.require 'este.labs.Storage'

class server.Storage extends este.labs.Storage

  ###*
    @param {app.Routes} routes
    @param {server.ElasticSearch} elastic
    @param {app.songs.Store} songsStore
    @constructor
    @extends {este.labs.Storage}
    @final
  ###
  constructor: (@routes, @elastic, @songsStore) ->
    super()

  ###*
    @override
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
            @songsStore.fromJson lastTenSongs: songs
      else
        @notFound()
