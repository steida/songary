goog.provide 'app.Storage'

goog.require 'common.Storage'
goog.require 'goog.async.Throttle'
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

    @pendingStores = new goog.structs.Set
    # NOTE(steida): It saves traffic and prevents race conditions.
    @savePendingStoresThrottle = new goog.async.Throttle @savePendingStores,
      Storage.THROTTLE_MS, @

    @localStorage.load @stores
    @listenStores()

    # TODO(steida): Do it on server side. It takes seconds on client.
    @firebase.simpleLogin @userStore

  @THROTTLE_MS: 1000

  savePendingStores: ->
    stores = @pendingStores.getValues()
    @pendingStores.clear()
    @saveStore store for store in stores

  ###*
    @param {app.Store} store
  ###
  saveStore: (store) ->
    @localStorage.set store
    if @firebase.userRef
      if @userStore.user && store instanceof app.user.Store
        # TODO(steida): JSON.parse JSON.stringify seems to be really stupid,
        # but idk how to workaround this issue better for now.
        # Firebase.set failed: First argument contains a function in property...
        # Investigate it.
        json = (`/** @type {Object} */`) JSON.parse JSON.stringify store.toJson()
        # TODO(steida): Use more granular approach.
        @firebase.userRef.set json

  listenStores: ->
    @stores.forEach (store) =>
      store.listen 'change', @onStoreChange.bind @, store

  ###*
    @param {app.Store} store
  ###
  onStoreChange: (store) ->
    @pendingStores.add store
    @savePendingStoresThrottle.fire()
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