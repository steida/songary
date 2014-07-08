goog.provide 'app.Storage'

goog.require 'este.labs.storage.Base'
goog.require 'goog.array'
goog.require 'goog.labs.userAgent.browser'
goog.require 'goog.storage.Storage'
goog.require 'goog.storage.mechanism.mechanismfactory'

class app.Storage extends este.labs.storage.Base

  ###*
    PATTERN(steida): This should be one place to change/sync app state.
    The goal is http://en.wikipedia.org/wiki/Persistent_data_structure,
    with all its benefits like global app undo etc.
    @param {app.Stores} stores
    @param {app.songs.Store} songsStore
    @constructor
    @extends {este.labs.storage.Base}
  ###
  constructor: (@stores, @songsStore) ->
    if @tryCreateLocalStorage()
      @updateStoreOnLocalStorageChange()
    @fetchStores()
    @listenStores()

  ###*
    @const
    @type {string}
  ###
  @LOCALSTORAGE_KEY: 'songary'

  ###*
    @type {app.Stores}
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
      when routes.mySong, routes.editMySong
        @songsStore.song = @songsStore.songByRoute route

  ###*
    NOTE(steida): Plain browser localStorage is used to store and retrieve
    app state snapshot for now. In future, consider:
    - http://git.yathit.com/ydn-db/wiki/Home
    - https://github.com/swannodette/mori
    - https://github.com/benjamine/jsondiffpatch
    @return {boolean}
    @protected
  ###
  tryCreateLocalStorage: ->
    mechanism = goog.storage.mechanism.mechanismfactory
      .createHTML5LocalStorage Storage.LOCALSTORAGE_KEY
    # For instance, Safari in private mode does not allow localStorage.
    return false if !mechanism
    @localStorage = new goog.storage.Storage mechanism
    true

  ###*
    NOTE(steida): This sync app state across tabs/windows.
    @protected
  ###
  updateStoreOnLocalStorageChange: ->
    # NOTE(steida): IE 9/10/11 implementation of window storage event is
    # broken. http://stackoverflow.com/a/4679754
    # Naive fix via document.hasFocus() does not work. Investigate it later.
    return if goog.labs.userAgent.browser.isIE()
    goog.events.listen window, 'storage', (e) =>
      browserEvent = e.getBrowserEvent()
      storeName = browserEvent.key.split('::')[1]
      store = goog.array.find @stores.all, (store) -> store.name == storeName
      return if !store
      # TODO(steida): Try/Catch in case of error. Report error to server.
      json = JSON.parse browserEvent.newValue
      goog.asserts.assertObject json
      store.fromJson json
      store.notify()

  ###*
    @protected
  ###
  fetchStores: ->
    return if !@localStorage
    @stores.all.forEach (store) =>
      json = @localStorage.get store.name
      return if !json
      # TODO(steida): Try/Catch in case of error. Report error to server.
      store.fromJson json

  ###*
    @protected
  ###
  listenStores: ->
    @stores.listen 'change', (e) =>
      store = e.target
      if @localStorage
        # TODO(steida): Try/Catch in case of error. Report error to server.
        @localStorage.set store.name, store.toJson()
      # TODO(steida): Server sync, consider diff.