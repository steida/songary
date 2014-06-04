goog.provide 'app.songs.Songs'

goog.require 'app.songs.Songs'

class app.songs.Songs

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