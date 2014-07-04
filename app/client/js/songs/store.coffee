goog.provide 'app.songs.Store'

goog.require 'app.songs.Song'
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
    if @contains song
      errors.push new app.ValidationError null,
        # TODO(steida): Localize.
        'Song with such name and artist already exists.'
    return errors if errors.length
    @songs.push song
    @notify_()
    []

  # Tohle je vec serializace...
  # ###*
  #   @param {app.songs.Song} song
  # ###
  # trimStrings: (song) ->
  #   for key, value of song

  ###*
    @param {app.songs.Song} song
  ###
  delete: (song) ->
    goog.array.remove @songs, song
    @notify_()

  ###*
    @param {este.Route} route
    @return {app.songs.Song}
  ###
  songByRoute: (route) ->
    goog.array.find @songs, (song) ->
      song['urlArtist'] == route.params['urlArtist'] &&
      song['urlName'] == route.params['urlName']

  ###*
    @param {app.songs.Song} song
    @return {boolean}
  ###
  contains: (song) ->
    goog.array.some @songs, (s) ->
      s.name == song.name &&
      s.artist == song.artist

  ###*
    @private
  ###
  notify_: ->
    @dispatchEvent 'change'