goog.provide 'app.main'

goog.require 'app.DiContainer'

###*
  @param {Object} data Server side data. Useful for config, preload, whatever.
###
app.main = (data) ->

  container = new app.DiContainer
  container.configure
    resolve: App
    with: element: document.body
  container.resolveApp()

  # TODO(steida): Move endpoint constant to server data.
  # myFirebaseRef = new Firebase 'https://shining-fire-6810.firebaseio.com/'
  # myFirebaseRef
  #   .child 'songs'
  #   .on 'value', (snapshot) ->
  #     console.log snapshot.val()

goog.exportSymbol 'app.main', app.main