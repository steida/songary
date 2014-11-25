goog.provide 'app.errors.SilentError'

goog.require 'goog.debug.Error'

class app.errors.SilentError extends goog.debug.Error

  ###*
    Silent error are errors not handled with alert in error reporter. For
    example, validations errors should be projected into form, not alerted.
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
