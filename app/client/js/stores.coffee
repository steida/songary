goog.provide 'app.Stores'

goog.require 'goog.events.EventTarget'

class app.Stores extends goog.events.EventTarget

  ###*
    @param {app.songs.Store} songsStore
    @constructor
    @extends {goog.events.EventTarget}
  ###
  constructor: (songsStore) ->
    super()
    # PATTERN(steida): This enables event bubbling, so we can listen
    # all various stores events at app.Stores instance.
    songsStore.setParentEventTarget @

    ###*
      @type {Array.<app.Store>}
    ###
    @all = [
      songsStore
    ]