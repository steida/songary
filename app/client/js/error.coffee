goog.provide 'app.Error'

goog.require 'goog.async.throwException'

class app.Error

  ###*
    TODO: Show something more beautiful then alert.
    TODO: Report error to server.
    @constructor
  ###
  constructor: ->

  handle: (reason) ->
    alert 'Application error. Sorry for that. Please reload browser.'
    # Ensure error is shown in console.
    goog.async.throwException reason if goog.DEBUG
    # Propagate error.
    throw reason
