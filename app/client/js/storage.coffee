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

    @startThrottledSaving()
    @localStorage.load @stores
    @listenStores()
    @firebase.simpleLogin()

  @THROTTLE_MS: 1000

  ###*
    Saves localStorage and network traffic. Not more then one sync per second.
    @protected
  ###
  startThrottledSaving: ->
    @savePendingStoresThrottled = new goog.async
      .Throttle @savePendingStores, Storage.THROTTLE_MS, @

  ###*
    @protected
  ###
  savePendingStores: ->
    stores = @pendingStores.getValues()
    @pendingStores.clear()
    @saveStore store for store in stores
    return

  ###*
    @param {este.labs.Store} store
    @param {boolean=} fromServer
    @protected
  ###
  saveStore: (store, fromServer = false) ->
    storeAsJson = @cloneAsJson store

    # Imho nepotřebuju, zakomentovat, odzkoušet, vykopnout.
    # Hmm, zruším a mám smyčku.
    # return if not @storeStateChanged store, storeAsJson

    @localStorage.set store, storeAsJson
    console.log 'localStorage set'

    if not fromServer
      if store instanceof app.user.Store && @userStore.user
        # TODO(steida): Encapsulate somehow.
        # storeAsJson.created ?= Firebase.ServerValue.TIMESTAMP
        # storeAsJson.updated = Firebase.ServerValue.TIMESTAMP
        console.log 'before firebase set'
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
  storeStateChanged: (store, storeAsJson) ->
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
    @param {goog.events.Event} e
    @protected
  ###
  onStoreChange: (store, e) ->
    # PATTERN(steida): Server changes are applied immediately.
    # NOTE(steida): Firebase dispatches events on client too. That seems to be
    # stupid but its ok, since on set Firebase.ServerValue.TIMESTAMP is
    # replaced with local time value, and we need to store that value on client.
    if e.server
      @saveStore store, true
      @notify()
      return

    # NOTE(steida): Postpone local changes to save traffic and localStorage.
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