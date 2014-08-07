goog.provide 'app.Storage'

goog.require 'common.Storage'
goog.require 'goog.asserts'
goog.require 'goog.object'

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

  ###*
    @param {app.Store} store
    @param {goog.events.Event} e
  ###
  onStoreChange: (store, e) ->
    @localStorage.set store
    # NOTE(steida): Persist data into Firebase when user is logged.
    if @userStore.user
      if store instanceof app.user.Store
        # NOTE(steida): JSON.parse JSON.stringify seems to be really stupid,
        # but idk how to workaround this issue better for now:
        # Firebase.set failed: First argument contains a function in property...
        # TODO(steida): Investigate it. Native .toJSON is too verbose.
        json = JSON.parse JSON.stringify store.toJson()
        goog.asserts.assertObject json
        # TODO(steida): Use more granular approach to store user data.
        @firebase.userRef.set json

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