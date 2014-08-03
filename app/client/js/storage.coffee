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
    @param {app.Store} appStore
    @param {app.user.Store} userStore
    @constructor
    @extends {common.Storage}
  ###
  constructor: (localStorage, appStore, @userStore) ->
    super appStore

    stores = [
      @appStore
      @userStore
    ]

    localStorage.load stores

    stores.forEach (store) => store.listen 'change', (e) =>
      # TODO(steida): Server sync, consider diff.
      localStorage.set store
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