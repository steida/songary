goog.provide 'app.Storage'

goog.require 'este.labs.storage.Base'

class app.Storage extends este.labs.storage.Base

  ###*
    @param {app.songs.Store} songsStore
    @constructor
    @extends {este.labs.storage.Base}
  ###
  constructor: (@songsStore) ->
    @stores = [@songsStore]
    @fetchStores()
    @listenStores()

  ###*
    @type {Array.<goog.events.Listenable>}
    @protected
  ###
  stores: null

  ###*
    @override
  ###
  load: (route, routes) ->
    switch route
      when routes.song
        # This is simulation of long XHR load...
        # We can also demonstrate "last click win" aka "pending navigation"
        # just by click to another link. Previous load will be canceled.
        new goog.Promise (resolve, reject) ->
          setTimeout resolve, 2000
          return
        .then =>
          # console.log 'Store updated.'
          @songsStore.song = @songsStore.songByRoute route
      else
        super route, routes

  ###*
    NOTE(steida): Now plain browser localStorage is used to store and retrieve
    app state snapshot. In future, we can leverage:
    - http://git.yathit.com/ydn-db/wiki/Home
    - https://github.com/swannodette/mori
    - https://github.com/benjamine/jsondiffpatch
    PATTERN(steida): This should be one place to change/sync app state. The goal
    is to use http://en.wikipedia.org/wiki/Persistent_data_structure
    with all its benefits.
    @protected
  ###
  fetchStores: ->

  ###*
    @protected
  ###
  listenStores: ->
    # for store in @stores
    #   store.listen
