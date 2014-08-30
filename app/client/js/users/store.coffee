goog.provide 'app.user.Store'

goog.require 'app.songs.Song'
goog.require 'este.labs.Store'
goog.require 'goog.array'

class app.user.Store extends este.labs.Store

  ###*
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: ->
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
    @type {Object} Firebase auth user.
  ###
  user: null

  setEmpty: ->
    @newSong = new app.songs.Song
    @songs = []
    @user = null

  ###*
    @return {Array.<app.songs.Song>}
  ###
  allSongs: ->
    goog.array.sortObjectsByKey @songs, 'name'
    @songs

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
  ###
  delete: (song) ->
    goog.array.remove @songs, song
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
    songs: @asObject @songs
    user: @user

  ###*
    @override
  ###
  fromJson: (json) ->
    @newSong = @instanceFromJson app.songs.Song, json.newSong
    # Because JSON stringify and parse ignore empty array, so we need '|| []'.
    @songs = @asArray(json.songs || []).map @instanceFromJson app.songs.Song
    @user = json.user

  ###*
    @param {Object} serverJson
    @param {Object} user Firebase auth user.
  ###
  mergeServerChanges: (serverJson, user) ->
    console.log 'mergeServerChanges' if goog.DEBUG
    @mergeUser serverJson, user
    # TODO: Rethink.
    localJson = @toJson()
    # TODO: Merge newSong.
    if serverJson.songs
      @mergeSongs localJson.songs, serverJson.songs
    @fromJson localJson

  ###*
    @param {Object} serverJson
    @param {Object} user Thirdparty auth user.
  ###
  mergeUser: (serverJson, user) ->
    # Always prefer thirdparty auth user data.
    @user = @authUserToAppUser user
    # Except createdAt.
    @user.createdAt = serverJson.user.createdAt

  ###*
    @param {Object} user Firebase auth user.
    @return {Object} user App user.
  ###
  authUserToAppUser: (user) ->
    displayName: user.displayName
    id: user.id
    provider: user.provider
    thirdPartyUserData: user.thirdPartyUserData
    uid: user.uid

  ###*
    @param {Object} localSongs
    @param {Object} serverSongs
  ###
  mergeSongs: (localSongs, serverSongs) ->
    for serverSongId, serverSong of serverSongs
      localSong = localSongs[serverSongId]
      if !localSong
        localSongs[serverSongId] = serverSong
        continue
      @mergeSong localSong, serverSong
    return

  ###*
    For now, server song always override local one.
    @param {Object} localSong
    @param {Object} serverSong
  ###
  mergeSong: (localSong, serverSong) ->
    localSong.name = serverSong.name
    localSong.artist = serverSong.artist
    localSong.lyrics = serverSong.lyrics

  ###*
    @param {boolean} userWasLogged
  ###
  clearOnLogout: (userWasLogged) ->
    if userWasLogged
      @setEmpty()
    else
      @user = null
