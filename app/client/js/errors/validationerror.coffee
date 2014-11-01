goog.provide 'app.errors.ValidationError'
goog.provide 'app.errors.ValidationError.toPromise'

goog.require 'app.errors.SilentError'

class app.errors.ValidationError extends app.errors.SilentError

  ###*
    @param {Array<app.errors.ValidationError.Error>} errors
    @constructor
    @extends {app.errors.SilentError}
  ###
  constructor: (@errors) ->
    super()

  ###*
    @typedef {{
      msg: (string),
      props: (Array<string>|undefined)
    }}
  ###
  @Error: null

  ###*
    @param {Array<app.errors.ValidationError.Error>} errors
    @return {goog.Promise}
  ###
  @toPromise: (errors) ->
    if errors.length
      goog.Promise.reject new app.errors.ValidationError errors
    else
      goog.Promise.resolve()

  ###*
    @type {Array<app.errors.ValidationError.Error>}
  ###
  errors: null

  ###*
    @override
  ###
  name: 'ValidationError'
