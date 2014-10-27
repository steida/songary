goog.provide 'app.Actions'

class app.Actions

  ###*
    @param {app.Dispatcher} dispatcher
    @constructor
  ###
  constructor: (@dispatcher) ->

  @ADD_NEW_SONG: 'add-new-song'
  @EMPTY_SONGS_TRASH: 'empty-songs-trash'
  @LOAD_ROUTE: 'load-route'
  @LOGIN: 'login'
  @LOGOUT: 'logout'
  @SEARCH_SONG: 'search-song'
  @SET_SONG_INTRASH: 'set-song-intrash'
  @SET_SONG_PROP: 'set-song-prop'

  addNewSong: ->
    @dispatcher.dispatch Actions.ADD_NEW_SONG

  emptySongsTrash: ->
    @dispatcher.dispatch Actions.EMPTY_SONGS_TRASH

  ###*
    @param {este.Route} route
    @param {Object} params
  ###
  loadRoute: (route, params) ->
    @dispatcher.dispatch Actions.LOAD_ROUTE, route: route, params: params

  login: ->
    @dispatcher.dispatch Actions.LOGIN

  logout: ->
    @dispatcher.dispatch Actions.LOGOUT

  ###*
    @param {string} query
  ###
  searchSong: (query) ->
    # TODO: Just query.
    @dispatcher.dispatch Actions.SEARCH_SONG, query: query

  ###*
    @param {app.songs.Song} song
    @param {boolean} inTrash
  ###
  setSongInTrash: (song, inTrash) ->
    @dispatcher.dispatch Actions.SET_SONG_INTRASH,
      song: song
      inTrash: inTrash

  ###*
    @param {app.songs.Song} song
    @param {string} name
    @param {string} value
  ###
  setSongProp: (song, name, value) ->
    @dispatcher.dispatch Actions.SET_SONG_PROP,
      song: song
      name: name
      value: value
