goog.provide 'app.Actions'

goog.require 'este.Actions'

class app.Actions extends este.Actions

  ###*
    @param {este.Dispatcher} dispatcher
    @constructor
    @extends {este.Actions}
  ###
  constructor: (dispatcher) ->
    super dispatcher

  @LOAD_ROUTE: 'load-route'

  @LOGIN: 'login'
  @LOGIN_FROM_FACEBOOK_REDIRECT: 'login-from-facebook-redirect'
  @LOGOUT: 'logout'

  @ADD_NEW_SONG: 'add-new-song'
  @EMPTY_SONGS_TRASH: 'empty-songs-trash'
  @SEARCH_SONG: 'search-song'
  @SET_SONG_INTRASH: 'set-song-intrash'
  @SET_SONG_PROP: 'set-song-prop'

  loadRoute: (route, params) ->
    @dispatch Actions.LOAD_ROUTE, route: route, params: params

  login: ->
    @dispatch Actions.LOGIN

  ###*
    @param {Object} auth
  ###
  loginFromFacebookRedirect: (auth) ->
    @dispatch Actions.LOGIN_FROM_FACEBOOK_REDIRECT, auth

  logout: ->
    @dispatch Actions.LOGOUT

  addNewSong: ->
    @dispatch Actions.ADD_NEW_SONG

  emptySongsTrash: ->
    @dispatch Actions.EMPTY_SONGS_TRASH

  ###*
    @param {string} query
  ###
  searchSong: (query) ->
    @dispatch Actions.SEARCH_SONG, query: query

  ###*
    @param {app.songs.Song} song
    @param {boolean} inTrash
  ###
  setSongInTrash: (song, inTrash) ->
    @dispatch Actions.SET_SONG_INTRASH,
      song: song
      inTrash: inTrash

  ###*
    @param {app.songs.Song} song
    @param {string} name
    @param {string} value
  ###
  setSongProp: (song, name, value) ->
    @dispatch Actions.SET_SONG_PROP,
      song: song
      name: name
      value: value
