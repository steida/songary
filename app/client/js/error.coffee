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
    # Don't report the same reason repeatedly.
    if reason != @previousReason
      alert 'Application error. Sorry for that. Please reload browser.'
      # Ensure error is shown in console.
      goog.async.throwException reason if goog.DEBUG
    @previousReason = reason

    # Propagate error.
    throw reason
