goog.provide 'app.Error'

goog.require 'goog.Promise'
goog.require 'goog.async.throwException'
goog.require 'goog.debug.ErrorReporter'

class app.Error

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    alreadyReported = {}

    if !goog.DEBUG
      goog.debug.ErrorReporter.install routes.api.clientErrors.url()

    # Defined in constuctor for use without binding: .thenCatch error.handle
    @handle = (reason) ->
      # Cancellation is not considered as a real error. For example, este.Router
      # cancels loading when another route is requested before previous is done.
      return if reason instanceof goog.Promise.CancellationError

      # Don't report already reported reason.
      reasonAsString = reason.toString()
      return if alreadyReported[reasonAsString]
      alreadyReported[reasonAsString] = true

      # TODO: Show something more beautiful then alert. There will be a button
      # to reload app. Not even think about auto reloading, very dangerous.
      alert 'Application error. Sorry for that. Please reload browser.'

      # Ensure error is shown in console and catcheable by reporter too.
      goog.async.throwException reason

      # Don't swallow errors. For example este.Router uses .then for url update.
      throw reason
