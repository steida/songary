goog.provide 'app.ValidationError'
goog.provide 'app.ValidationError.toPromise'

goog.require 'goog.Promise'
goog.require 'goog.debug.Error'

class app.ValidationError extends goog.debug.Error

  ###*
    @param {Array.<app.ValidationError.Error>} errors
    @constructor
    @extends {goog.debug.Error}
    @final
  ###
  constructor: (@errors) ->
    super()

  ###*
    @typedef {{
      msg: (string),
      props: (Array.<string>|undefined)
    }}
  ###
  @Error: null

  ###*
    @param {Array.<app.ValidationError.Error>} errors
    @return {goog.Promise}
  ###
  @toPromise: (errors) ->
    if errors.length
      goog.Promise.reject new app.ValidationError errors
    else
      goog.Promise.resolve()

  ###*
    @type {Array.<app.ValidationError.Error>}
  ###
  errors: null

  ###*
    @override
  ###
  name: 'validationerror'
