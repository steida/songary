goog.provide 'app.routes.Store'

goog.require 'este.Store'
goog.require 'goog.net.HttpStatus'

class app.routes.Store extends este.Store

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.songs.Store} songsStore
    @param {app.users.Store} usersStore
    @param {este.Dispatcher} dispatcher
    @param {este.Router} router
    @constructor
    @extends {este.Store}
  ###
  constructor: (@actions, @routes, @storage,
      @songsStore, @usersStore, @dispatcher, @router) ->

    @dispatcher.register (action, payload) =>
      switch action
        when app.Actions.LOAD_ROUTE then @loadRoute_ payload
        when app.Actions.LOGIN, app.Actions.LOGIN_FROM_FACEBOOK_REDIRECT
          @login_()

  ###*
    @type {Function}
    @private
  ###
  render_: null

  ###*
    @type {Object}
    @private
  ###
  lastRouteMatch_: null

  ###*
    @param {Function} render
  ###
  start: (render) ->
    @render_ = render
    @routes.addToEste @router, (route, params) =>
      @lastRouteMatch_ = route: route, params: params
      @actions.loadRoute route, params
    @router.start()

  ###*
    @param {Object} payload
    @param {boolean=} noWaitFor
    @return {goog.Promise|number}
    @private
  ###
  loadRoute_: (payload, noWaitFor) ->
    {route, params} = payload

    stores = [
      @songsStore
    ].map (store) -> store.dispatcherId

    promise = if noWaitFor
      goog.Promise.resolve()
    else
      @dispatcher.waitFor stores

    promise
      .then => @checkHttpStatus_ route, params
      .then => @routes.setActive route, params
      .thenCatch (httpStatus) => @routes.trySetErrorRoute httpStatus
      .then => @render_()

  ###*
    @param {este.Route} route
    @param {Object} params
  ###
  checkHttpStatus_: (route, params) ->
    if !@usersStore.isLogged() && route in [
      @routes.me
    ]
      throw goog.net.HttpStatus.NOT_FOUND

  login_: ->
    @dispatcher.waitFor [@usersStore.dispatcherId]
      .then =>
        # Reload route after login.
        @loadRoute_ @lastRouteMatch_, true
