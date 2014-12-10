goog.provide 'app.errors.Error'

goog.require 'goog.debug.Error'

class app.errors.Error extends goog.debug.Error

  ###*
    This error represents app business logic errors like validation, wrong pass,
    offline connection, etc. These errors are innocuous therefore not reported
    to the server. Many of them should handled at responsible stores, but for
    example XHR error can be dispatched anywhere, therefore error reporter has
    to handle them.
    @param {*=} opt_msg The message associated with the error.
    @constructor
    @extends {goog.debug.Error}
  ###
  constructor: (opt_msg) ->
    super opt_msg

  ###*
    @override
  ###
  name: 'AppError'
