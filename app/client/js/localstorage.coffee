goog.provide 'app.LocalStorage'

goog.require 'goog.array'
goog.require 'goog.asserts'
goog.require 'goog.storage.Storage'
goog.require 'goog.storage.mechanism.mechanismfactory'
goog.require 'goog.string'

class app.LocalStorage

  ###*
    @param {goog.labs.pubsub.BroadcastPubSub} pubSub
    @constructor
  ###
  constructor: (@pubSub) ->
    mechanism = goog.storage.mechanism.mechanismfactory
      .createHTML5LocalStorage LocalStorage.Key.APP

    # In Safari/iOS private browsing mode, localStorage is not available.
    if mechanism
      @isAvailable = true
      @localStorage = new goog.storage.Storage mechanism
      @ensureVersion()
      @contextId = goog.string.getRandomString()

  ###*
    @enum {string}
  ###
  @Key:
    APP: 'songary'
    VERSION: 'version'

  ###*
    @enum {string}
  ###
  @Topic:
    STORE_CHANGE: 'store-change'

  ###*
    @type {number}
  ###
  @VERSION: 1

  ###*
    @type {goog.labs.pubsub.BroadcastPubSub}
    @protected
  ###
  pubSub: null

  ###*
    @type {boolean}
    @protected
  ###
  isAvailable: false

  ###*
    @type {goog.storage.Storage}
    @protected
  ###
  localStorage: null

  ###*
    Browsing context id.
    @type {string}
  ###
  contextId: ''

  ###*
    @type {boolean}
  ###
  publishOnChange_: true

  ###*
    @protected
  ###
  ensureVersion: ->
    version = @localStorage.get LocalStorage.Key.VERSION
    return if version
    @localStorage.set LocalStorage.Key.VERSION, LocalStorage.VERSION

  ###*
    Sync stores with localStorage across browsing contexts with the same origin.
    @param {Array.<este.Store>} stores
  ###
  sync: (stores) ->
    return if !@isAvailable
    for store in stores
      @fetch store
      @publishOnChange store
    @subscribeChanges stores

  ###*
    @param {este.Store} store
    @protected
  ###
  fetch: (store) ->
    json = @localStorage.get store.name
    return if !json
    goog.asserts.assertObject json
    store.fromJson json

  ###*
    @param {este.Store} store
    @protected
  ###
  publishOnChange: (store) ->
    store.listen 'change', (e) =>
      return if !@publishOnChange_
      @pubSub.publish LocalStorage.Topic.STORE_CHANGE, @contextId, store.name

  ###*
    @param {Array.<este.Store>} stores
    @protected
  ###
  subscribeChanges: (stores) ->
    @pubSub.subscribe LocalStorage.Topic.STORE_CHANGE, (contextId, name) =>
      store = goog.array.find stores, (store) -> store.name == name
      if contextId == @contextId
        @localStorage.set store.name, store.toJson()
      else
        @publishOnChange_ = false
        @fetch store
        @publishOnChange_ = true
