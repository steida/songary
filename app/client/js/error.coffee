goog.provide 'app.Error'

goog.require 'goog.async.throwException'
goog.require 'goog.debug.ErrorReporter'

class app.Error

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    reporter = goog.debug.ErrorReporter.install routes.api.clientErrors.url()
    alreadyReported = {}

    # Defined in constuctor to use without binding: .thenCatch error.handle
    @handle = (reason) ->
      reasonAsString = reason.toString()

      # Don't report the same reason repeatedly.
      return if alreadyReported[reasonAsString]
      alreadyReported[reasonAsString] = true

      # TODO: Show something more beautiful then alert. There will be a button
      # to reload app. Not even think about auto reloading, very dangerous.
      alert 'Application error. Sorry for that. Please reload browser.'

      # Ensure error is shown in console and catcheable by reporter.
      goog.async.throwException reason

      # Don't swallow errors. For instance, este.Router cancels loading on error.
      throw reason
