goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.Actions} actions
    @param {app.Dispatcher} dispatcher
    @param {app.Facebook} facebook
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.react.App} reactApp
    @param {este.Router} router
    @constructor
  ###
  constructor: (element, actions, dispatcher, facebook, routes, storage, reactApp, router) ->

    storage.sync()

    dispatcher.register (action, payload) =>
      switch action
        when app.Actions.SYNC_VIEW
          React.render reactApp.component(), element

    routes.addToEste router, (route, params) ->
      actions.loadRoute route, params
        .then -> routes.setActive route, params
        .thenCatch (reason) -> routes.trySetErrorRoute reason
        .then -> actions.syncView()
    router.start()

    facebook.init()
