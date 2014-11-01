goog.provide 'app.errors.InnocuousError'

goog.require 'goog.debug.Error'

class app.errors.InnocuousError extends goog.debug.Error

  ###*
    Innocuous error. Show alert, but don't report error to server.
    @param {*=} opt_msg The message associated with the error.
    @constructor
    @extends {goog.debug.Error}
  ###
  constructor: (opt_msg) ->
    super opt_msg

  ###*
    @override
  ###
  name: 'InnocuousError'
