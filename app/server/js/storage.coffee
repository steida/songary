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

    promise = @firebase.loadByRoute route, @routes, params
    return promise if promise
    @ok()
