goog.provide 'app.Storage'

goog.require 'common.Storage'
goog.require 'goog.array'
goog.require 'goog.labs.userAgent.browser'
goog.require 'goog.storage.Storage'
goog.require 'goog.storage.mechanism.mechanismfactory'

class app.Storage extends common.Storage

  ###*
    PATTERN(steida): This should be one place to change/sync app state.
    The goal is http://en.wikipedia.org/wiki/Persistent_data_structure
    with all its benefits.
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

    @listenStores @onStoreChange
    @localStorage.load @stores
    # TODO(steida): Do it on server side. It can takes seconds on client.
    @firebase.simpleLogin @userStore

  listenStores: (callback) ->
    @stores.forEach (store) => store.listen 'change', callback.bind @, store

  onStoreChange: (store, e) ->
    @localStorage.set store
    # NOTE(steida): Persist data into Firebase if user is logged.
    if @userStore.user
      if store instanceof app.user.Store
        # imho bude řvát, je na to neco v goog.object?
        # goog.object.unsafeClone ok?
        @firebase
          .userRefOf @userStore.user
          .set store.toJson()
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