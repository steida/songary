goog.provide 'app.Storage'

goog.require 'este.labs.Storage'
goog.require 'goog.async.Throttle'
goog.require 'goog.structs.Set'

class app.Storage extends este.labs.Storage

  ###*
    Storage manages stores state. Store itself should not load nor save anything
    directly since it's used both on client and server side.
    @param {app.LocalStorage} localStorage
    @param {app.Firebase} firebase
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @param {app.songs.Store} songsStore
    @constructor
    @extends {este.labs.Storage}
    @final
  ###
  constructor: (@localStorage, @firebase, @routes, @userStore, @songsStore) ->
    super()

    @stores = [@userStore]
    @pendingStores = new goog.structs.Set
    @save = new goog.async.Throttle @savePendingStores, Storage.THROTTLE_MS, @

    @localStorage.load @stores
    @listenStores()
    @firebase.simpleLogin()

  @THROTTLE_MS: 1000

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
    if store instanceof app.user.Store
      if @firebase.userRef
        console.log '@userRef.set json' if goog.DEBUG
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

  ###*
    @override
  ###
  load: (route, params) ->
    switch route
      when @routes.me
        if !@userStore.isLogged()
          return @notFound()
      when @routes.mySong, @routes.editSong
        if !@userStore.songById params.id
          return @notFound()
      when @routes.song
        return @firebase
          .getSongByUrl params.urlArtist + '/' + params.urlName
          .then (value) =>
            # TODO: Handle better notfound.
            if !value
              throw goog.net.HttpStatus.NOT_FOUND
            # TODO: fromJson
            @songsStore.songsByUrl = value
      when @routes.songs
        return @firebase
          .getLastTenSongs()
          .then (value) =>
            if !value
              throw goog.net.HttpStatus.NOT_FOUND
            @songsStore.fromJson
              lastTenSongs: value
    @ok()
