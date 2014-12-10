goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.LocalStorage} localStorage
    @param {app.facebook.Store} facebookStore
    @param {app.react.App} reactApp
    @param {app.routes.Store} routesStore
    @constructor
  ###
  constructor: (element, localStorage, facebookStore, reactApp, routesStore) ->

    localStorage.start()
    facebookStore.start()
    routesStore.start ->
      React.render reactApp.component(), element
