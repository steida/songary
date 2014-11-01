goog.provide 'app.errors.SilentError'

goog.require 'goog.debug.Error'

class app.errors.SilentError extends goog.debug.Error

  ###*
    No real error. Therefore no alert.
    @param {*=} opt_msg The message associated with the error.
    @constructor
    @extends {goog.debug.Error}
  ###
  constructor: (opt_msg) ->
    super opt_msg

  ###*
    @override
  ###
  name: 'CancellationError'
