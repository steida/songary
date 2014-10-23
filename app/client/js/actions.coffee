goog.provide 'app.Actions'

class app.Actions

  ###*
    @param {app.Dispatcher} dispatcher
    @constructor
  ###
  constructor: (@dispatcher) ->

  @LOAD_ROUTE: 'load-route'
  @LOGIN: 'login'
  @LOGOUT: 'logout'
  @SEARCH_SONG: 'search-song'

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
