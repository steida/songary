goog.provide 'app.songs.Song'

class app.songs.Song

  ###*
    @param {string} name
    @param {string} author
    @constructor
  ###
  constructor: (@name, @author) ->

  ###*
    @type {string}
  ###
  name: ''

  ###*
    @type {string}
  ###
  author: ''