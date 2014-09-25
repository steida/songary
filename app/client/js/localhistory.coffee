goog.provide 'app.LocalHistory'

class app.LocalHistory

  ###*
    Server can update local state anytime with any value. For example, when
    some disconnected device is reconnected, it will save its waiting changes,
    which can be obsolete, and these changes can override newer data on another
    device. There is no way how workaround such behaviour without locks.
    Ideal solution is operational transformation, but implementation is tricky.
    So our solution is to locally store all previous states. It's ideal task
    for persistent data structure, but I'm still evaluating immutable-js and
    other libraries. In the meantime, let's store previous states as a whole.
    @constructor
  ###
  constructor: ->

    ###*
      @type {Object.<string, Array.<Object>>}
    ###
    @history = {}

  @MAX_ITEMS_IN_ARRAY: 200

  ###*
    @param {este.labs.Store} store
    @param {Object} json
  ###
  update: (store, json) ->
    @storePreviousState_ store
    store.fromJson json

  ###*
    TODO: Store into LocalStorage once persistent data structure will used.
    @param {este.labs.Store} store
    @private
  ###
  storePreviousState_: (store) ->
    array = @history[store.name] ?= []
    deepCopy = JSON.parse JSON.stringify store.toJson()
    array.push deepCopy
    array.shift() if array.length > LocalHistory.MAX_ITEMS_IN_ARRAY

  ###*
    @param {este.labs.Store} store
    @return {Array.<Object>}
  ###
  of: (store) ->
    @history[store.name] || []
