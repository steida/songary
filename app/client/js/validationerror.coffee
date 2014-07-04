goog.provide 'app.ValidationError'

class app.ValidationError

  ###*
    @param {?string} prop
    @param {string} message
    @constructor
  ###
  constructor: (@prop, @message) ->