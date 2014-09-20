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
      when @routes.editSong, @routes.mySong, @routes.trash, @routes.me
        return @notFound()
      when @routes.song
        # TODO: Preload store or 404
        return @notFound()
      when @routes.songs
        @elastic.getLastTenSongs()
          .then (songs) => @songsStore.fromJson lastTenSongs: songs
    @ok()
