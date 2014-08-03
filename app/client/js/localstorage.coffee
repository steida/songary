goog.provide 'app.LocalStorage'

goog.require 'common.Storage'
goog.require 'goog.array'
goog.require 'goog.labs.userAgent.browser'
goog.require 'goog.storage.Storage'
goog.require 'goog.storage.mechanism.mechanismfactory'

class app.LocalStorage

  ###*
    @constructor
  ###
  constructor: ->
    @tryCreateLocalStorage()

  ###*
    @const
    @type {string}
  ###
  localStorageKey: 'songary'

  ###*
    Can be null, Safari in private mode does not allow localStorage.
    @type {goog.storage.Storage}
    @protected
  ###
  localStorage: null

  ###*
    @protected
  ###
  tryCreateLocalStorage: ->
    mechanism = goog.storage.mechanism.mechanismfactory
      .createHTML5LocalStorage @localStorageKey
    return if !mechanism
    @localStorage = new goog.storage.Storage mechanism

  ###*
    @param {Array.<app.Store>} stores
  ###
  load: (stores) ->
    return if !@localStorage
    @loadFromJson stores
    @listenWindowStorage stores

  ###*
    @param {Array.<app.Store>} stores
    @protected
  ###
  loadFromJson: (stores) ->
    stores.forEach (store) =>
      json = @localStorage.get store.name
      return if !json
      # TODO(steida): Try/Catch in case of error. Report error to server.
      store.fromJson json

  ###*
    Sync app state across tabs/windows.
    @param {Array.<app.Store>} stores
    @protected
  ###
  listenWindowStorage: (stores) ->
    # IE 9/10/11 implementation of window storage event is broken. Check:
    # http://stackoverflow.com/a/4679754
    return if goog.labs.userAgent.browser.isIE()

    goog.events.listen window, 'storage', (e) =>
      browserEvent = e.getBrowserEvent()
      storeName = browserEvent.key.split('::')[1]
      store = goog.array.find stores, (store) -> store.name == storeName
      return if !store
      # TODO(steida): Try/Catch in case of error. Report error to server.
      json = JSON.parse browserEvent.newValue
      goog.asserts.assertObject json
      store.fromJson json
      store.notify()

  ###*
    @param {app.Store} store
  ###
  set: (store) ->
    return if !@localStorage
    @localStorage.set store.name, store.toJson()