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

  # ###*
  #   TODO: If ok, move to este.labs.Store.
  #   @type {?number}
  # ###
  # created: null
  #
  # ###*
  #   TODO: If ok, move to este.labs.Store.
  #   @type {?number}
  # ###
  # updated: null

  ###*
    @type {app.songs.Song}
  ###
  newSong: null

  ###*
    @type {Array.<app.songs.Song>}
  ###
  songs: null

  ###*
    @type {Object}
  ###
  user: null

  setEmpty: ->
    @songs = []
    @newSong = new app.songs.Song
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
    # created: @created
    newSong: @newSong
    songs: @asObject @songs
    # updated: @updated
    user: @getJsonUser @user

  ###*
    @override
  ###
  fromJson: (json) ->
    # @created = json.created
    @newSong = @instanceFromJson app.songs.Song, json.newSong
    # Because JSON stringify and parse ignore empty array, so we need '|| []'.
    @songs = @asArray(json.songs || []).map @instanceFromJson app.songs.Song
    @user = @getJsonUser json.user
    # @updated = json.updated

  # PATTERN: Use only server unique props, because user is going to be synced
  # with localStorage which is shared across browser windows.
  getJsonUser: (user) ->
    return null if !user
    displayName: user.displayName
    id: user.id
    provider: user.provider
    thirdPartyUserData: user.thirdPartyUserData
    uid: user.uid

  ###*
    @param {Object} authUser
    @param {Object} serverUserStoreJson
  ###
  updateFromServer: (authUser, serverUserStoreJson) ->
    console.log 'updateFromServer' if goog.DEBUG
    @user = authUser
    localUserStoreJson = @toJson()
    # serverUserStoreJson can be null for new user.
    if serverUserStoreJson
      @mergeSongs localUserStoreJson.songs, serverUserStoreJson.songs
    @fromJson localUserStoreJson
    @serverNotify()

  ###*
    @param {Object} localSongs
    @param {Object} serverSongs
  ###
  mergeSongs: (localSongs, serverSongs) ->
    # TODO: It is really needed?
    return if !serverSongs
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
    PATTERN: Logout deletes all user data in memory and localStorage, but only
    if user was logged at least once. We don't want to delete localStorage of
    not yet logged user aka new visitor.
    @param {boolean} userWasLoggedOnce
  ###
  onLogout: (userWasLoggedOnce) ->
    if userWasLoggedOnce
      @setEmpty()
    else
      @user = null
    @notify()
