goog.provide 'app.Storage'

goog.require 'este.labs.Storage'
goog.require 'goog.async.Throttle'
goog.require 'goog.structs.Map'
goog.require 'goog.structs.Set'

class app.Storage extends este.labs.Storage

  ###*
    @param {app.LocalStorage} localStorage
    @param {app.Firebase} firebase
    @param {app.user.Store} userStore
    @constructor
    @extends {este.labs.Storage}
    @final
  ###
  constructor: (@localStorage, @firebase, @userStore) ->
    super()

    @stores = [
      @userStore
    ]

    @storesStates = new goog.structs.Map
    @pendingStores = new goog.structs.Set

    @createThrottledSave()
    @localStorage.load @stores
    @listenStores()
    @firebase.simpleLogin()

  @THROTTLE_MS: 1000

  ###*
    @override
  ###
  load: (route, params, routes) ->
    switch route
      when routes.mySong, routes.editMySong
        @userStore.activeSong = @userStore.songById params.id
        return @notFound() if not @userStore.activeSong
        @ok()
      else
        @ok()

  ###*
    Throttling for app state persistence. It saves traffic and localStorage.
    @private
  ###
  createThrottledSave: ->
    @savePendingStoresThrottled = new goog.async
      .Throttle @savePendingStores, Storage.THROTTLE_MS, @

  ###*
    @private
  ###
  savePendingStores: ->
    stores = @pendingStores.getValues()
    @pendingStores.clear()
    @saveStore store for store in stores
    return

  ###*
    TODO: Handle errors.
    @param {este.labs.Store} store
    @param {boolean=} fromServer
    @private
  ###
  saveStore: (store, fromServer = false) ->
    console.log 'storage.saveStore, from server: ', fromServer if goog.DEBUG
    storeAsJson = @deepCopy store.toJson()

    # TODO: Do it smarter.
    return if not @storeStateChanged store, storeAsJson

    @localStorage.set store, storeAsJson
    if not fromServer
      isUserStoreWithUser = store instanceof app.user.Store && @userStore.user
      if isUserStoreWithUser
        @firebase.userRef.set storeAsJson

  ###*
    @private
  ###
  listenStores: ->
    @stores.forEach (store) =>
      store.listen 'change', @onStoreChange.bind @, store

  ###*
    @param {este.labs.Store} store
    @param {goog.events.Event} e
    @private
  ###
  onStoreChange: (store, e) ->
    # PATTERN: Server changes are applied immediately.
    if e.server
      @saveStore store, true
      @notify()
      return

    # Postpone local changes to save server and localStorage traffic.
    @pendingStores.add store
    @savePendingStoresThrottled.fire()
    @notify()

  ###*
    Check if store state has changed.
    @param {este.labs.Store} store
    @param {Object} storeAsJson
    @return {boolean}
  ###
  storeStateChanged: (store, storeAsJson) ->
    storeAsJsonString = JSON.stringify storeAsJson
    return false if @storesStates.get(store) == storeAsJsonString
    @storesStates.set store, storeAsJsonString
    true
