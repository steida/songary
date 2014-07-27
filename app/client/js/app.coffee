goog.provide 'App'

class App

  ###*
    @param {este.Router} router
    @param {app.Routes} routes
    @param {app.react.App} reactApp
    @param {Element} element
    @param {app.Title} appTitle
    @param {app.Storage} storage
    @constructor
  ###
  constructor: (router, routes, reactApp, element, appTitle, storage) ->

    onRouterError = (e) ->
      # PATTERN(steida): Here we can handle various errors.
      # For server error, use alert something like "Try it later...".
      # For client error, log it, then show link to reload app in popup.
      # Never reload automatically since it can cause loop.
      # Use goog.DEBUG to detect development/production mode.
      # All sync/async errors are handled since we are using promises.
      # Use e.reason to check what happen.
      console.log e.reason

    syncUI = ->
      document.title = appTitle.get()
      React.renderComponent reactApp.create(), element

    routes.addToEste router
    router.listen 'error', onRouterError

    # PATTERN(steida): Listen all listenables representing app state here.
    # Don't worry about performance, all data should be fetched already.
    # Only data supposed to be shown are processed with React virtual DOM diff.
    routes.listen 'change', syncUI
    storage.listen 'change', syncUI
    router.start()