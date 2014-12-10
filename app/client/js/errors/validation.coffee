goog.provide 'app.errors.Validation'
goog.provide 'app.errors.Validation.toPromise'

goog.require 'app.errors.Error'

class app.errors.Validation extends app.errors.Error

  ###*
    @param {Array<app.errors.Validation.Error>} errors
    @constructor
    @extends {app.errors.Error}
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
    @param {Array<app.errors.Validation.Error>} errors
    @return {goog.Promise}
  ###
  @toPromise: (errors) ->
    if errors.length
      goog.Promise.reject new app.errors.Validation errors
    else
      goog.Promise.resolve()

  ###*
    @type {Array<app.errors.Validation.Error>}
  ###
  errors: null

  ###*
    @override
  ###
  name: 'ValidationError'
