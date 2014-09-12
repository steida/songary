goog.provide 'server.Storage'

goog.require 'este.labs.Storage'

class server.Storage extends este.labs.Storage

  ###*
    @param {app.Firebase} firebase
    @param {app.Routes} routes
    @param {app.songs.Store} songsStore
    @constructor
    @extends {este.labs.Storage}
    @final
  ###
  constructor: (@firebase, @routes, @songsStore) ->
    super()

  ###*
    @override
  ###
  load: (route, params) ->
    switch route
      when @routes.editSong, @routes.mySong, @routes.trash, @routes.me
        return @notFound()
      when @routes.song
        return @firebase.getSongByUrl params.name + '/' + params.artist
          .then (value) =>
            if !value
              throw goog.net.HttpStatus.NOT_FOUND
            @songsStore.songsByUrl = value
      when @routes.songs
        return @firebase
          .getLastTenSongs()
          .then (value) =>
            if !value
              throw goog.net.HttpStatus.NOT_FOUND
            @songsStore.fromJson
              lastTenSongs: value
    @ok()
