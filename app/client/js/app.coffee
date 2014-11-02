goog.provide 'App'

class App

  ###*
    @param {app.Actions} actions
    @param {app.FrontPage} frontPage
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.facebook.Store} facebookStore
    @param {este.Router} router
    @constructor
  ###
  constructor: (actions, frontPage, routes, storage, facebookStore, router) ->

    frontPage.init()
    storage.init()
    facebookStore.init()

    routes.addToEste router, (route, params) ->
      actions.loadRoute route, params
        .then -> routes.setActive route, params
        .thenCatch (reason) -> routes.trySetErrorRoute reason
        .then -> actions.syncView()
    router.start()
