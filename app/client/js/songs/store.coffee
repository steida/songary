goog.provide 'app.songs.Store'

goog.require 'app.Store'
goog.require 'app.songs.Song'

class app.songs.Store extends app.Store

  ###*
    @constructor
    @extends {app.Store}
    @implements {SongsStoreProps}
  ###
  constructor: ->
    super 'songs'
    @songs = []
    @newSong = new app.songs.Song

  ###*
    @type {Array.<app.songs.Song>}
  ###
  @songs: null

  ###*
    @type {app.songs.Song}
  ###
  @newSong: null

  ###*
    @desc app.Title
  ###
  @MSG_HOME: goog.getMsg 'Songary | Your personal songbook'

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
    @notify()
    []

  ###*
    @param {app.songs.Song} song
  ###
  delete: (song) ->
    goog.array.remove @songs, song
    @notify()

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
    @notify()

  ###*
    @return {Array.<app.ValidationError>}
  ###
  addNewSong: ->
    errors = @add @newSong
    if !errors.length
      @newSong = new app.songs.Song
      @notify()
    errors

  ###*
    @override
  ###
  toJson: ->
    newSong: @newSong
    songs: @songs

  ###*
    @override
  ###
  fromJson: (json) ->
    @songs = json.songs.map @instanceFromJson app.songs.Song
    @newSong = @instanceFromJson app.songs.Song, json.newSong