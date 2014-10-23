goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.Actions} actions
    @param {app.Facebook} facebook
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.react.App} reactApp
    @param {este.Router} router
    @constructor
  ###
  constructor: (element, actions, facebook, routes, storage, reactApp, router) ->

    storage.init()

    routes.addToEste router, (route, params) ->
      actions.loadRoute route, params
        # Set active route if everything is fine.
        .then -> routes.setActive route, params
        # Try set error route for known errors. Only 404 for now.
        .thenCatch (reason) -> routes.trySetErrorRoute reason
        # Everything is ok, rerender view.
        .then -> React.render reactApp.component(), element
    router.start()

    facebook.init()
