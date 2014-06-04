goog.provide 'App'

class App

  ###*
    @param {este.Router} router
    @param {app.Routes} routes
    @param {app.react.App} reactApp
    @param {Element} element
    @constructor
  ###
  constructor: (router, routes, reactApp, element) ->
    routes.addToEste router
    router.start()

    appComponent = React.renderComponent reactApp.create(), element

    routes.listen este.Routes.EventType.CHANGE, (e) ->
      document.title = routes.getActive().title
      appComponent.forceUpdate()