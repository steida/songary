goog.provide 'server.Storage'

goog.require 'este.labs.Storage'

class server.Storage extends este.labs.Storage

  ###*
    @param {app.Routes} routes
    @param {app.Firebase} firebase
    @constructor
    @extends {este.labs.Storage}
    @final
  ###
  constructor: (@routes, @firebase) ->
    super()

  ###*
    @override
  ###
  load: (route, params) ->
    switch route
      when @routes.editSong, @routes.mySong, @routes.trash, @routes.me
        return @notFound()
      when @routes.song
        return @notFound()
        # @firebase
        #   .getSongByUrl params.name + '/' + params.artist
        #   .then (value) ->
        #     console.log value
        #   .thenCatch (reason) ->
        #     console.log reason

    @ok()
