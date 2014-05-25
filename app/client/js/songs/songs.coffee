goog.provide 'app.songs.Song'

goog.require 'app.songs.Song'

class app.songs.Song

  ###*
    @constructor
  ###
  constructor: ->
    @items = []

  ###*
    @type {Array.<app.songs.Song>}
  ###
  items: null

  clearAll: ->
    @items.length = 0