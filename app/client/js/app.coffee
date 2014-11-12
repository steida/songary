goog.provide 'App'

class App

  ###*
    @param {Element} element
    @param {app.Dispatcher} dispatcher
    @param {app.LocalStorage} localStorage
    @param {app.react.App} reactApp
    @param {app.facebook.Store} facebookStore
    @param {app.routes.Store} routesStore
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (element, dispatcher, localStorage, reactApp,
      facebookStore, routesStore, usersStore) ->

    dispatcher.register (action, payload) ->
      switch action
        when app.Actions.RENDER_APP
          React.render reactApp.component(), element

    localStorage.sync [usersStore]
    facebookStore.init()
    routesStore.start()
