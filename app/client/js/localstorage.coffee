goog.provide 'app.LocalStorage'

goog.require 'goog.array'
goog.require 'goog.labs.userAgent.browser'
goog.require 'goog.storage.Storage'
goog.require 'goog.storage.mechanism.mechanismfactory'

class app.LocalStorage

  ###*
    @constructor
  ###
  constructor: ->
    @tryCreate_()
    @migrate_()

  ###*
    @enum {string}
  ###
  @Keys:
    STORE_PREFIX: 'store:'
    USER: 'user'
    VERSION: 'version'

  ###*
    @private
  ###
  localStorageKey_: 'songary'

  ###*
    @private
  ###
  localStorageVersion_: 1

  ###*
    Can be null, Safari in private mode does not allow localStorage object.
    @type {goog.storage.Storage}
    @private
  ###
  localStorage_: null

  ###*
    @private
  ###
  tryCreate_: ->
    mechanism = goog.storage.mechanism.mechanismfactory
      .createHTML5LocalStorage @localStorageKey_
    return if !mechanism
    @localStorage_ = new goog.storage.Storage mechanism
    @ensureVersion_()

  ###*
    @private
  ###
  ensureVersion_: ->
    version = @localStorage_.get LocalStorage.Keys.VERSION
    return if version
    @localStorage_.set LocalStorage.Keys.VERSION, @localStorageVersion_

  ###*
    @private
  ###
  migrate_: ->
    return if !@localStorage_
    storageVersion = Number @localStorage_.get LocalStorage.Keys.VERSION
    scriptVersion = @localStorageVersion_
    userOrig = @localStorage_.get LocalStorage.Keys.USER
    try
      migrateVersion() for migrateVersion in [
        =>
          # Example:
          # user = @localStorage_.get LocalStorage.Keys.USER
          # user.songs = user.songs.map (song) ->
          #   lyrics = song.lyrics
          #   delete song.lyrics
          #   song.llyrics = lyrics
          #   song
          # @localStorage_.set LocalStorage.Keys.USER, user
        =>
          # console.log 'from 2 to 3'
      ].slice storageVersion - 1, scriptVersion - 1
    catch e
      # TODO: Report error to server.
      @localStorage_.set LocalStorage.Keys.USER, userOrig
      return
    @localStorage_.set LocalStorage.Keys.VERSION, scriptVersion

  ###*
    @param {Array.<este.labs.Store>} stores
  ###
  load: (stores) ->
    return if !@localStorage_
    @loadFromJson_ stores
    @listenWindowStorage_ stores

  ###*
    @param {Array.<este.labs.Store>} stores
    @private
  ###
  loadFromJson_: (stores) ->
    stores.forEach (store) =>
      json = @localStorage_.get @getPrefixedStoreKey_ store
      return if !json
      # TODO: Try/Catch in case of error. Report error to server.
      store.fromJson json

  ###*
    Sync app state across browser tabs/windows with the same domain origin.
    @param {Array.<este.labs.Store>} stores
    @private
  ###
  listenWindowStorage_: (stores) ->
    # IE 9/10/11 implementation of window storage event is broken. Check:
    # http://stackoverflow.com/a/4679754
    return if goog.labs.userAgent.browser.isIE()

    goog.events.listen window, 'storage', (e) =>
      # TODO: Reload if localStorageVersion_ changed.
      browserEvent = e.getBrowserEvent()
      store = @tryGetStore browserEvent.key, stores
      return if !store

      # Because FirebaseSimpleLogin does not propagate login state across
      # browser windows, we need to track change manually.
      if store instanceof app.user.Store
        userWasLogged = !!store.user

      # TODO: Try/Catch in case of error. Report error to server.
      json = (`/** @type {Object} */`) JSON.parse browserEvent.newValue
      store.fromJson json
      store.notify @

      # Reload browser on user login state change.
      if store instanceof app.user.Store
        userLogged = !userWasLogged && store.user
        userLogout = userWasLogged && !store.user
        location.reload() if userLogged || userLogout

  ###*
    @param {string} key
    @param {Array.<este.labs.Store>} stores
  ###
  tryGetStore: (key, stores) ->
    prefix = @localStorageKey_ + '::' + LocalStorage.Keys.STORE_PREFIX
    storeName = key.slice prefix.length
    return null if !storeName
    goog.array.find stores, (store) ->
      store.name == storeName

  ###*
    @param {este.labs.Store} store
    @param {Object} json
  ###
  set: (store, json) ->
    return if !@localStorage_
    @localStorage_.set @getPrefixedStoreKey_(store), json

  ###*
    @param {este.labs.Store} store
    @return {string}
    @private
  ###
  getPrefixedStoreKey_: (store) ->
    LocalStorage.Keys.STORE_PREFIX + store.name
