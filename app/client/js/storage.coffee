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
        # This is simulation of long XHR load...
        # We can also demonstrate "last click win" aka "pending navigation"
        # just by clicking to another link. Previous loading will be canceled.
        new goog.Promise (resolve, reject) ->
          setTimeout resolve, 2000
          return
        .then =>
          console.log 'Store updated.'
          @songsStore.song = @songsStore.songByRoute route
      else
        super route, routes


    # Tohle je vec serializace...
    # ###*
    #   @param {app.songs.Song} song
    # ###
    # trimStrings: (song) ->
    #   for key, value of song