goog.provide 'app.Storage'

goog.require 'este.labs.Storage'
goog.require 'goog.async.Throttle'
goog.require 'goog.structs.Set'

class app.Storage extends este.labs.Storage

  ###*
    @param {app.LocalStorage} localStorage
    @param {app.Routes} routes
    @param {app.Xhr} xhr
    @param {app.songs.Store} songsStore
    @param {app.user.Store} userStore
    @constructor
    @extends {este.labs.Storage}
    @final
  ###
  constructor: (@localStorage, @routes, @xhr, @songsStore, @userStore) ->
    super()
    @localStorage.sync [@userStore]

    # @stores = [@userStore]
    # @pendingStores = new goog.structs.Set
    # @save = new goog.async.Throttle @savePendingStores, Storage.THROTTLE_MS, @

    # @localStorage.load @stores
    # @listenStores()

  # @THROTTLE_MS: 1000

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
          .get @routes.api.songs.byUrl.url params
          .then (songs) =>
            return @notFound() if !songs.length
            @songsStore.fromJson songsByUrl: songs
      when @routes.songs
        @ok()
      when @routes.recentlyUpdatedSongs
        @xhr
          .get @routes.api.songs.recentlyUpdated.url()
          .then (songs) =>
            @songsStore.fromJson recentlyUpdatedSongs: songs
      else
        @notFound()

  # ###*
  #   TODO: Handle error.
  #   @private
  # ###
  # savePendingStores: ->
  #   stores = @pendingStores.getValues()
  #   @pendingStores.clear()
  #   for store in stores
  #     json = @deepCopy store.toJson()
  #     @saveStoreToClient store, json
  #     @saveStoreToServer store, json
  #   return
  #
  # ###*
  #   @param {este.labs.Store} store
  #   @param {Object} json
  #   @private
  # ###
  # saveStoreToClient: (store, json) ->
  #   # console.log 'storage.saveStoreToClient' if goog.DEBUG
  #   @localStorage.set store, json
  #
  # ###*
  #   @param {este.labs.Store} store
  #   @param {Object} json
  #   @private
  # ###
  # saveStoreToServer: (store, json) ->
  #   # console.log 'storage.saveStoreToServer' if goog.DEBUG
  #   if store instanceof app.user.Store
  #     if @firebase.userRef
  #       # console.log '@userRef.set json' if goog.DEBUG
  #       @firebase.sync -> @userRef.set json
  #
  # ###*
  #   @private
  # ###
  # listenStores: ->
  #   @stores.forEach (store) =>
  #     store.listen 'change', @onStoreChange.bind @, store
  #
  # ###*
  #   @param {este.labs.Store} store
  #   @param {goog.events.Event} e
  #   @private
  # ###
  # onStoreChange: (store, e) ->
  #   # Ignore changes from the same origin browser window or tab.
  #   if e.target instanceof app.LocalStorage
  #     return
  #
  #   # Save changes from Firebase to LocalStorage.
  #   if e.target instanceof app.Firebase
  #     @saveStoreToClient store, @deepCopy store.toJson()
  #     return
  #
  #   # Save all changes throttled.
  #   @pendingStores.add store
  #   @save.fire()
