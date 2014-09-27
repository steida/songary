goog.provide 'app.Storage'

goog.require 'este.labs.Storage'
goog.require 'goog.async.Throttle'
goog.require 'goog.structs.Set'

class app.Storage extends este.labs.Storage

  ###*
    Storage manages stores state. Store itself should not load nor save anything
    directly since it's used both on client and server side.
    @param {app.Firebase} firebase
    @param {app.LocalStorage} localStorage
    @param {app.Routes} routes
    @param {app.Xhr} xhr
    @param {app.songs.Store} songsStore
    @param {app.user.Store} userStore
    @constructor
    @extends {este.labs.Storage}
    @final
  ###
  constructor: (@firebase, @localStorage, @routes, @xhr, @songsStore, @userStore) ->
    super()

    @stores = [@userStore]
    @pendingStores = new goog.structs.Set
    @save = new goog.async.Throttle @savePendingStores, Storage.THROTTLE_MS, @

    @localStorage.load @stores
    @listenStores()
    @firebase.simpleLogin()

  @THROTTLE_MS: 1000

  ###*
    @override
  ###
  load: (route, params) ->
    switch route
      when @routes.about, @routes.home, @routes.newSong, @routes.trash
        @ok()
      when @routes.me
        return @notFound() if !@userStore.isLogged()
        @ok()
      when @routes.mySong, @routes.editSong
        return @notFound() if !@userStore.songById params.id
        @ok()
      when @routes.song
        @xhr
          .get @routes.api.songsByUrl.url params
          .then (songs) =>
            return @notFound() if !songs.length
            @songsStore.fromJson songsByUrl: songs
      when @routes.songs
        @ok()
      when @routes.recentlyUpdatedSongs
        @xhr
          .get @routes.api.recentlyUpdatedSongs.url()
          .then (songs) =>
            @songsStore.fromJson recentlyUpdatedSongs: songs
      else
        @notFound()

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
    # console.log 'storage.saveStoreToClient' if goog.DEBUG
    @localStorage.set store, json

  ###*
    TODO: Try JSONPatch, https://github.com/facebook/immutable-js/issues/52.
    @param {este.labs.Store} store
    @param {Object} json
    @private
  ###
  saveStoreToServer: (store, json) ->
    # console.log 'storage.saveStoreToServer' if goog.DEBUG
    if store instanceof app.user.Store
      if @firebase.userRef
        # console.log '@userRef.set json' if goog.DEBUG
        @firebase.sync -> @userRef.set json

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
    # Ignore changes from the same origin browser window or tab.
    if e.target instanceof app.LocalStorage
      return

    # Save changes from Firebase to LocalStorage.
    if e.target instanceof app.Firebase
      @saveStoreToClient store, @deepCopy store.toJson()
      return

    # Save all changes throttled.
    @pendingStores.add store
    @save.fire()
