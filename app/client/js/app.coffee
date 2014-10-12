goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.Dispatcher} dispatcher
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.react.App} reactApp
    @param {este.Router} router
    @constructor
  ###
  constructor: (element, dispatcher, routes, storage, reactApp, router) ->

    dispatcher.register (action, payload) ->
      if action == 'router-load'
        storage.load payload.route, payload.params
          .then -> routes.setActive payload.route, payload.params
          .thenCatch (reason) -> routes.trySetErrorRoute reason
          .then -> React.renderComponent reactApp.component(), element

    routes.addToEste router, (route, params) ->
      dispatcher.dispatch 'router-load', route: route, params: params
    router.start()
