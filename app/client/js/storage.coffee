goog.provide 'app.Storage'

goog.require 'este.labs.storage.Base'

goog.require 'goog.storage.Storage'
goog.require 'goog.storage.mechanism.mechanismfactory'

class app.Storage extends este.labs.storage.Base

  ###*
    PATTERN(steida): This should be one place to change/sync app state.
    The goal is http://en.wikipedia.org/wiki/Persistent_data_structure,
    with all its benefits like global app undo etc.
    @param {app.songs.Store} songsStore
    @constructor
    @extends {este.labs.storage.Base}
  ###
  constructor: (@songsStore) ->
    @stores = [@songsStore]
    @tryCreateLocalStorage()
    @fetchStores()
    @listenStores()

  ###*
    @const
    @type {string}
  ###
  @LOCALSTORAGE_KEY: 'songary'

  ###*
    @type {Array.<app.Store>}
    @protected
  ###
  stores: null

  ###*
    @type {goog.storage.Storage}
    @protected
  ###
  localStorage: null

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
    NOTE(steida): Plain browser localStorage is used to store and retrieve
    app state snapshot for now. In future, consider:
    - http://git.yathit.com/ydn-db/wiki/Home
    - https://github.com/swannodette/mori
    - https://github.com/benjamine/jsondiffpatch
    @protected
  ###
  tryCreateLocalStorage: ->
    mechanism = goog.storage.mechanism.mechanismfactory
      .createHTML5LocalStorage Storage.LOCALSTORAGE_KEY
    # Fot instance, Safari in private mode does not allow localStorage.
    return if !mechanism
    @localStorage = new goog.storage.Storage mechanism

  ###*
    @protected
  ###
  fetchStores: ->
    return if !@localStorage
    @stores.forEach (store) =>
      json = @localStorage.get store.name
      return if !json
      # TODO(steida): Try catch for case of wrong json data.
      # Report error to https endpoint.
      store.fromJson json

  ###*
    @protected
  ###
  listenStores: ->
    return if !@localStorage
    @stores.forEach (store) =>
      store.listen 'change', =>
        @localStorage.set store.name, store.toJson()