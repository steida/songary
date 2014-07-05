goog.provide 'App'

class App

  ###*
    @param {este.Router} router
    @param {app.Routes} routes
    @param {app.react.App} reactApp
    @param {Element} element
    @param {app.Title} appTitle
    @constructor
  ###
  constructor: (router, routes, reactApp, element, appTitle) ->

    syncView = ->
      if @component
        @component.forceUpdate()
      else
        @component = React.renderComponent reactApp.create(), element
      document.title = appTitle.get()

    onRouterError = (e) ->
      # NOTE(steida): Here we can handle various errors.
      # For error from server, say something like "Try it later.",
      # for client error, log them then reload browser probably.
      # We can decide by: e.reason
      alert e.reason
      # NOTE(steida): App can be in wrong state, so reload it.
      forceReloadToEnsureFreshScripts = true
      location.reload forceReloadToEnsureFreshScripts

    routes.addToEste  router
    routes.listen este.Routes.EventType.CHANGE, syncView
    router.listen este.Router.EventType.ERROR, onRouterError
    router.start()