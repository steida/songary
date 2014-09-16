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
      # when @routes.api.song
      #   client.index
      #     index: 'songary'
      #     type: 'song'
      #     id: '1'
      #     body:
      #       title: 'Test 1'
      #       tags: ['y', 'z']
      #       published: true
      #   , (error, response) ->
      #     console.log arguments


    promise = @firebase.loadByRoute route, @routes, params
    return promise if promise
    @ok()
