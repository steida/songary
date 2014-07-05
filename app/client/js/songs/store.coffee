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
    @newSong = new app.songs.Song

  ###*
    @desc app.Title
  ###
  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'

  ###*
    @type {Array.<app.songs.Song>}
  ###
  songs: null

  ###*
    @type {app.songs.Song}
  ###
  newSong: null

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
      errors.push new app.ValidationError 'name',
        'Song with such name and artist already exists.'
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
    @param {string} prop
    @param {string} value
  ###
  setNewSong: (prop, value) ->
    @newSong[prop] = value
    @newSong.updateUrlNames()
    @notify_()

  ###*
    @return {Array.<app.ValidationError>}
  ###
  addNewSong: ->
    errors = @add @newSong
    if !errors.length
      @newSong = new app.songs.Song
    errors

  ###*
    @private
  ###
  notify_: ->
    @dispatchEvent 'change'