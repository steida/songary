goog.provide 'app.Actions'

class app.Actions

  ###*
    @param {app.Dispatcher} dispatcher
    @constructor
  ###
  constructor: (@dispatcher) ->

  @LOAD_ROUTE: 'load-route'

  ###*
    @param {este.Route} route
    @param {Object} params
  ###
  loadRoute: (route, params) ->
    @dispatcher.dispatch Actions.LOAD_ROUTE,
      route: route
      params: params

# @Actions:
#   LOGIN: 'login'
#   LOGOUT: 'logout'
# ###*
#   @return {!goog.Promise}
# ###
# login: ->
#   @dispatcher.dispatch Store.Actions.LOGIN
#
# ###*
#   @return {!goog.Promise}
# ###
# logout: ->
#   @dispatcher.dispatch Store.Actions.LOGOUT
#
