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
  todos: null

  ###*
    @return {Array.<app.songs.Song>}
  ###
  getTodos: ->
    @todos.items

  ###*
    @param {string} title
  ###
  add: (title) ->
    @todos.add title
    @notify_()

  clearAll: ->
    @todos.clearAll()
    @notify_()

  ###*
    @param {app.songs.Song} todo
  ###
  remove: (todo) ->
    goog.array.remove @todos.items, todo
    @notify_()

  ###*
    @private
  ###
  notify_: ->
    @dispatchEvent 'change'