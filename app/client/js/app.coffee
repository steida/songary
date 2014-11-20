goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {este.Dispatcher} dispatcher
    @param {app.ErrorReporter} errorReporter
    @param {app.LocalStorage} localStorage
    @param {app.facebook.Store} facebookStore
    @param {app.react.App} reactApp
    @param {app.routes.Store} routesStore
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (element, dispatcher, errorReporter, localStorage, facebookStore,
      reactApp, routesStore, usersStore) ->

    dispatcher.register (action, payload) ->
      switch action
        when app.Actions.RENDER_APP
          React.render reactApp.component(), element

    errorReporter.use dispatcher
    localStorage.use [usersStore]
    facebookStore.init()
    routesStore.start()
