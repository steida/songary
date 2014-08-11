goog.provide 'app.Storage'

goog.require 'common.Storage'
goog.require 'goog.async.Throttle'
goog.require 'goog.object'
goog.require 'goog.structs.Map'
goog.require 'goog.structs.Set'

class app.Storage extends common.Storage

  ###*
    PATTERN(steida): React components read from and write to app stores.
    app.Storage listen app stores change events and decide how stores should be
    persisted and synced with backend.
    @param {app.LocalStorage} localStorage
    @param {app.Firebase} firebase
    @param {app.Store} appStore
    @param {app.user.Store} userStore
    @constructor
    @extends {common.Storage}
  ###
  constructor: (@localStorage, @firebase,
      @appStore,
      @userStore) ->

    super @appStore

    @stores = [@appStore, @userStore]
    @storesStates = new goog.structs.Map
    @pendingStores = new goog.structs.Set
    @savePendingStoresThrottled = new goog.async
      .Throttle @savePendingStores, Storage.THROTTLE_MS, @

    @localStorage.load @stores
    @listenStores()
    @firebase.simpleLogin()

  ###*
    NOTE(steida): Saves traffic and prevents race conditions for
    localStorage store events too. Probably because get and set methods
    aren't called in one transaction.
  ###
  @THROTTLE_MS: 1000

  ###*
    @protected
  ###
  savePendingStores: ->
    stores = @pendingStores.getValues()
    @pendingStores.clear()
    @saveStore store for store in stores

  ###*
    @param {este.labs.Store} store
    @protected
  ###
  saveStore: (store) ->
    storeAsJson = @cloneAsJson store
    return if not @storeStateHasChanged store, storeAsJson
    console.log 'saveStore called'
    @localStorage.set store, storeAsJson
    if @firebase.userRef
      if store instanceof app.user.Store && @userStore.user
        # TODO(steida): Use more granular approach.
        @firebase.userRef.set storeAsJson

  ###*
    Deep copy without functions. JSON.parse JSON.stringify might not be
    the fastest, http://jsperf.com/deep-copy-vs-json-stringify-json-parse,
    but it's robust. Firebase and the others need pure JSON (normalized
    object without functions).
    @param {este.labs.Store} store
    @return {Object}
    @protected
  ###
  cloneAsJson: (store) ->
    (`/** @type {Object} */`) JSON.parse JSON.stringify store.toJson()

  ###*
    Check if store state has changed.
    NOTE(steida): I wish I have Something like React, but for state diff.
    @param {este.labs.Store} store
    @param {Object} storeAsJson
    @return {boolean}
  ###
  storeStateHasChanged: (store, storeAsJson) ->
    storeAsJsonString = JSON.stringify storeAsJson
    return false if @storesStates.get(store) == storeAsJsonString
    @storesStates.set store, storeAsJsonString
    true

  ###*
    @protected
  ###
  listenStores: ->
    @stores.forEach (store) =>
      store.listen 'change', @onStoreChange.bind @, store

  ###*
    @param {este.labs.Store} store
    @protected
  ###
  onStoreChange: (store) ->
    @pendingStores.add store
    @savePendingStoresThrottled.fire()
    @notify()

  ###*
    @override
  ###
  promiseOf: (route, routes) ->
    switch route
      when routes.mySong, routes.editMySong
        song = @userStore.songByRoute route
        if song then @ok() else @notFound()
      else
        @ok()