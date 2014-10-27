goog.provide 'app.Actions'

class app.Actions

  ###*
    @param {app.Dispatcher} dispatcher
    @constructor
  ###
  constructor: (@dispatcher) ->

  @ADD_NEW_SONG: 'add-new-song'
  @LOAD_ROUTE: 'load-route'
  @LOGIN: 'login'
  @LOGOUT: 'logout'
  @SEARCH_SONG: 'search-song'

  ###*
    @return {goog.Promise}
  ###
  addNewSong: ->
    @dispatcher.dispatch Actions.ADD_NEW_SONG

  ###*
    @param {este.Route} route
    @param {Object} params
    @return {goog.Promise}
  ###
  loadRoute: (route, params) ->
    @dispatcher.dispatch Actions.LOAD_ROUTE, route: route, params: params

  ###*
    @return {goog.Promise}
  ###
  login: ->
    @dispatcher.dispatch Actions.LOGIN

  ###*
    @return {goog.Promise}
  ###
  logout: ->
    @dispatcher.dispatch Actions.LOGOUT

  ###*
    @param {string} query
    @return {goog.Promise}
  ###
  searchSong: (query) ->
    @dispatcher.dispatch Actions.SEARCH_SONG, query: query
