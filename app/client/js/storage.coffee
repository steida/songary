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
        return @notFound() if !@userStore.songById params.id
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
    TODO: Handle error.
    @private
  ###
  savePendingStores: ->
    stores = @pendingStores.getValues()
    @pendingStores.clear()
    for store in stores
      json = @deepCopy store.toJson()
      @saveStoreToClient store, json
      @saveStoreToServer store, json
    return

  ###*
    @param {este.labs.Store} store
    @param {Object} json
    @private
  ###
  saveStoreToClient: (store, json) ->
    console.log 'storage.saveStoreToClient' if goog.DEBUG
    @localStorage.set store, json

  ###*
    TODO: Try JSONPatch, https://github.com/facebook/immutable-js/issues/52.
    @param {este.labs.Store} store
    @param {Object} json
    @private
  ###
  saveStoreToServer: (store, json) ->
    console.log 'storage.saveStoreToServer' if goog.DEBUG
    isUserStoreWithUser = store instanceof app.user.Store && store.user
    if isUserStoreWithUser
      @firebase.userRef.set json

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
    console.log 'onStoreChange e.server == ' + e.server if goog.DEBUG

    # return if not @storeStateChanged store, @deepCopy store.toJson()

    # Apply server changes immediately, on client only.
    if e.server
      @saveStoreToClient store, @deepCopy store.toJson()
      @notify()
      return

    # Postpone local changes to save server and localStorage traffic.
    @pendingStores.add store
    @savePendingStoresThrottled.fire()
    @notify()

  ###*
    Check if store state has changed.
    @param {este.labs.Store} store
    @param {Object} json
    @return {boolean}
  ###
  storeStateChanged: (store, json) ->
    jsonString = JSON.stringify json
    return false if @storesStates.get(store) == jsonString
    @storesStates.set store, jsonString
    true
