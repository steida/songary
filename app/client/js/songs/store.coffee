goog.provide 'app.songs.Store'

goog.require 'este.labs.Store'
goog.require 'app.songs.Song'

class app.songs.Store extends este.labs.Store

  ###*
    @constructor
    @extends {este.labs.Store}
    @implements {SongsStoreProps}
  ###
  constructor: ->
    super 'songs'
    @songs = []
    @newSong = new app.songs.Song

  ###*
    @type {Array.<app.songs.Song>}
  ###
  songs: null

  ###*
    @type {app.songs.Song}
  ###
  newSong: null

  ###*
    @type {app.songs.Song}
  ###
  song: null

  ###*
    @return {Array.<app.songs.Song>}
  ###
  all: ->
    @songs

  ###*
    PATTERN(steida): This is example why it's good to manipulate app model only
    through stores. We need to validate both song and songs, and we need to
    change not only the model. Stores ftw.
    @return {Array.<app.ValidationError>}
  ###
  addNewSong: ->
    errors = @newSong.validate()
    if @contains @newSong
      errors.push new app.ValidationError 'name',
        'Song with such name and artist already exists.'
    return errors if errors.length
    @songs.push @newSong
    @newSong = new app.songs.Song
    @notify()
    []

  saveSong: ->
    errors = @song.validate()
    return errors if errors.length

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
    @param {app.songs.Song} song
    @param {string} prop
    @param {string} value
  ###
  updateSong: (song, prop, value) ->
    song[prop] = value
    song.update()
    @notify()

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
    @newSong = @instanceFromJson app.songs.Song, json.newSong
    @songs = json.songs.map @instanceFromJson app.songs.Song