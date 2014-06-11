goog.provide 'app.songs.Store'

goog.require 'goog.array'
goog.require 'goog.events.EventTarget'

class app.songs.Store extends goog.events.EventTarget

  ###*
    @constructor
    @extends {goog.events.EventTarget}
    @final
  ###
  constructor: ->
    super()
    @songs = []

  ###*
    @type {Array.<app.songs.Song>}
    @private
  ###
  songs: null

  ###*
    @return {Array.<app.songs.Song>}
  ###
  all: ->
    @songs

  ###*
    @param {app.songs.Song} song
    @return {Array.<app.ValidationError>}
  ###
  add: (song) ->
    errors = song.validate()
    return errors if errors.length
    @songs.push song
    @notify_()
    []

  ###*
    @param {app.songs.Song} song
  ###
  delete: (song) ->
    goog.array.remove @songs, song
    @notify_()

  ###*
    @private
  ###
  notify_: ->
    @dispatchEvent 'change'