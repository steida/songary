goog.provide 'app.user.Store'

goog.require 'app.songs.Song'
goog.require 'este.labs.Store'
goog.require 'goog.array'

class app.user.Store extends este.labs.Store

  ###*
    TODO: Split to more stores.
    @param {app.LocalHistory} localHistory
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: (@localHistory) ->
    super 'user'
    @setEmpty()

  ###*
    @type {app.songs.Song}
  ###
  newSong: null

  ###*
    @type {Array.<app.songs.Song>}
  ###
  songs: null

  ###*
    @type {Object} Auth user.
  ###
  user: null

  setEmpty: ->
    @newSong = new app.songs.Song
    @songs = []
    @user = null

  ###*
    @return {Array.<app.songs.Song>}
  ###
  songsSortedByName: ->
    songs = @songs.slice 0
    goog.array.sortObjectsByKey songs, 'name'
    songs

  ###*
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

  ###*
    @param {app.songs.Song} song
    @param {boolean} inTrash
  ###
  trashSong: (song, inTrash) ->
    song.inTrash = inTrash
    @notify()

  ###*
    @param {string} id
    @return {app.songs.Song}
  ###
  songById: (id) ->
    goog.array.find @songs, (song) -> song.id == id

  ###*
    @param {este.Route} route
    @return {app.songs.Song}
  ###
  songByRoute: (route) ->
    @songById route.params.id

  ###*
    @param {app.songs.Song} song
    @return {boolean}
  ###
  contains: (song) ->
    goog.array.some @songs, (item) ->
      return false if item.inTrash
      item.name == song.name &&
      item.artist == song.artist

  ###*
    @param {app.songs.Song} song
    @param {string} prop
    @param {string} value
  ###
  updateSong: (song, prop, value) ->
    song[prop] = value
    song.update()
    @notify()

  deleteSongsInTrash: ->
    goog.array.removeAllIf @songs, (song) -> song.inTrash
    @notify()

  ###*
    @override
  ###
  toJson: ->
    json =
      newSong: @newSong
      user: @user
    if @songs.length
      json.songs = @asObject @songs
    json

  ###*
    @override
  ###
  fromJson: (json) ->
    @newSong = @instanceFromJson app.songs.Song, json.newSong
    @songs = @asArray(json.songs || {}).map @instanceFromJson app.songs.Song
    @user = @authUserToAppUser json.user if json.user

  ###*
    @param {Object} authUser Auth user.
    @return {Object} user App user.
  ###
  authUserToAppUser: (authUser) ->
    createdAt: authUser.createdAt
    displayName: authUser.displayName
    id: authUser.id
    provider: authUser.provider
    thirdPartyUserData: authUser.thirdPartyUserData
    uid: authUser.uid

  ###*
    @param {boolean} userWasLogged
  ###
  clearOnLogout: (userWasLogged) ->
    if userWasLogged
      @setEmpty()
    else
      @user = null

  ###*
    @return {boolean}
  ###
  isLogged: ->
    return !!@user

  ###*
    @param {app.songs.Song} song
    @return {Array.<string>}
  ###
  getSongLyricsLocalHistory: (song) ->
    seen = {}

    @localHistory
      .of @
      .map (store) ->
        if store.newSong.id == song.id
          return store.newSong.lyrics.trim()
        store.songs?[song.id]?.lyrics.trim()
      .filter (lyrics) ->
        # Exists and has more than one word.
        lyrics && lyrics.split(/\s+/).length > 1
      .filter (lyrics) ->
        return false if seen[lyrics]
        seen[lyrics] = true
