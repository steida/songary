goog.provide 'app.Storage'

goog.require 'este.labs.storage.Base'

class app.Storage extends este.labs.storage.Base

  ###*
    @param {app.songs.Store} songsStore
    @constructor
    @extends {este.labs.storage.Base}
  ###
  constructor: (@songsStore) ->

  ###*
    @override
  ###
  load: (route, routes) ->
    switch route
      when routes.song
        # NOTE(steida) Can be server side requested ofc.
        @songsStore.song = @songsStore.songByRoute route
    super route, routes

    # new goog.Promise (resolve, reject) ->
    #   setTimeout resolve, 2000
    #   return
    # .then =>
    #   console.log goog.now()