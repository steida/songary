goog.provide 'app.songs.Store'

goog.require 'goog.array'
goog.require 'goog.events.EventTarget'

class app.songs.Store extends goog.events.EventTarget

  ###*
    @param {app.songs.Song} songs
    @constructor
    @extends {goog.events.EventTarget}
    @final
  ###
  constructor: (@songs) ->
    super()

  ###*
    @type {app.songs.Song}
    @private
  ###
  songs: null

  ###*
    @return {Array.<app.songs.Song>}
  ###
  getTodos: ->
    @songs.items

  ###*
    @param {string} title
  ###
  add: (title) ->
    @songs.add title
    @notify_()

  clearAll: ->
    @songs.clearAll()
    @notify_()

  ###*
    @param {app.songs.Song} song
  ###
  remove: (song) ->
    goog.array.remove @songs.items, song
    @notify_()

  ###*
    @private
  ###
  notify_: ->
    @dispatchEvent 'change'