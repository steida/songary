goog.provide 'app.users.Store'

goog.require 'app.errors.ValidationError'
goog.require 'app.songs.Song'
goog.require 'app.users.User'
goog.require 'este.Store'
goog.require 'goog.array'

class app.users.Store extends este.Store

  ###*
    @param {app.Dispatcher} dispatcher
    @param {app.ErrorReporter} errorReporter
    @param {app.LocalHistory} localHistory
    @param {app.facebook.Store} facebookStore
    @constructor
    @extends {este.Store}
  ###
  constructor: (@dispatcher, @errorReporter, @localHistory, @facebookStore) ->
    super()
    @name = 'user'
    @setEmpty_()

    @dispatcherId = @dispatcher.register (action, payload) =>
      switch action
        when app.Actions.ADD_NEW_SONG then @addNewSong_()
        when app.Actions.EMPTY_SONGS_TRASH then @emptySongsTrash_()
        when app.Actions.LOGIN then @login_()
        when app.Actions.LOGOUT then @logout_()
        when app.Actions.SET_SONG_INTRASH then @trashSong_ payload
        when app.Actions.SET_SONG_PROP then @setSongProp_ payload

  ###*
    Not yet added new song, persisted in localStorage.
    @type {app.songs.Song}
  ###
  newSong: null

  ###*
    User songs persisted in localStorage.
    @type {Array<app.songs.Song>}
  ###
  songs: null

  ###*
    @type {app.users.User}
  ###
  user: null

  ###*
    @private
  ###
  setEmpty_: ->
    @newSong = new app.songs.Song
    @songs = []
    @user = new app.users.User

  ###*
    @return {goog.Promise}
    @private
  ###
  addNewSong_: ->
    @newSong.validate()
      .then =>
        return if !@contains @newSong
        throw new app.errors.ValidationError [
          msg: "Song #{@newSong.name}, #{@newSong.artist} already exists."
          props: ['name', 'artist']
        ]
      .then =>
        @songs.push @newSong
        @newSong = new app.songs.Song
        @notify()

  emptySongsTrash_: ->
    goog.array.removeAllIf @songs, (song) -> song.inTrash
    @notify()

  ###*
    @private
  ###
  login_: ->
    @dispatcher
      .waitFor [@facebookStore.dispatcherId]
      .then =>
        @fromJson user: app.users.User.fromFacebook @facebookStore.me
        @errorReporter.userName = @user.name

  ###*
    It's important to delete all user data on logout.
    @private
  ###
  logout_: ->
    @setEmpty_()
    @errorReporter.userName = ''
    @notify()

  ###*
    @param {Object} payload
  ###
  trashSong_: (payload) ->
    {song, inTrash} = payload
    song.inTrash = inTrash
    @notify()

  ###*
    @param {Object} payload
  ###
  setSongProp_: (payload) ->
    {song, name, value} = payload
    song[name] = value
    song.computeProps()
    @notify()

  ###*
    @return {Array<app.songs.Song>}
  ###
  songsSortedByName: ->
    songs = @songs.slice 0
    goog.array.sortObjectsByKey songs, 'name'
    songs

  ###*
    @return {Array<app.songs.Song>}
  ###
  songsSortedByUpdatedAt: ->
    songs = @songs.slice 0
    songs.sort (a, b) -> new Date(b.updatedAt) - new Date(a.updatedAt)
    songs

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
    @override
  ###
  toJson: ->
    newSong: @newSong
    songs: @songs
    user: @user

  ###*
    @override
  ###
  fromJson: (json) ->
    if json.newSong
      @newSong = new app.songs.Song json.newSong
    if json.songs
      @songs = json.songs.map (json) => new app.songs.Song json
    if json.user
      @user = new app.users.User json.user
    @notify()

  ###*
    @return {boolean}
  ###
  isLogged: ->
    return !!@user.email

  ###*
    @param {app.songs.Song} song
    @return {Array<string>}
  ###
  getSongLyricsLocalHistory: (song) ->
    []
    # seen = {}
    #
    # @localHistory
    #   .of @
    #   .map (store) ->
    #     if store.newSong.id == song.id
    #       return store.newSong?.lyrics?.trim()
    #     store.songs?[song.id]?.lyrics?.trim()
    #   .filter (lyrics) ->
    #     # Exists and has more than one word.
    #     lyrics && lyrics.split(/\s+/).length > 1
    #   .filter (lyrics) ->
    #     return false if seen[lyrics]
    #     seen[lyrics] = true

  # ###*
  #   @param {app.songs.Song} song
  # ###
  # setSongPublisher: (song) ->
  #   # song.publisher = @user.uid
  #   # @notify()
  #
  # ###*
  #   @param {app.songs.Song} song
  # ###
  # removeSongPublisher: (song) ->
  #   # song.publisher = null
  #   # @notify()

  ###*
    @param {app.songs.Song} song
  ###
  savePublishedSongToDevice: (song) ->
    @songs.push song
    @notify()
