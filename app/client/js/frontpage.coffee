goog.provide 'app.FrontPage'

class app.FrontPage

  ###*
    @param {Element} element
    @param {app.Dispatcher} dispatcher
    @param {app.react.App} reactApp
    @constructor
  ###
  constructor: (@element, @dispatcher, @reactApp) ->

  init: ->
    @dispatcher.register (action, payload) =>
      switch action
        when app.Actions.SYNC_VIEW
          React.render @reactApp.component(), @element
