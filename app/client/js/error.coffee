goog.provide 'app.Error'

goog.require 'goog.Promise'
goog.require 'goog.debug.ErrorReporter'

class app.Error

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    @alreadyReported_ = Object.create null

    if !goog.DEBUG
      @reporter = goog.debug.ErrorReporter.install routes.api.clientErrors.url()

  ###*
    @param {*} reason
    @param {string} action
  ###
  handle: (reason, action) ->
    # Cancellation is not considered as a real error. For example, este.Router
    # cancels loading when another route is requested before previous is done.
    return if reason instanceof goog.Promise.CancellationError

    # Don't report already reported reason. TODO: Consider throttling.
    # reasonAsString = reason.toString()
    # return if @alreadyReported_[reasonAsString]
    # @alreadyReported_[reasonAsString] = true

    if reason instanceof app.Xhr.OfflineError
      alert reason.message
      return

    # TODO: Show something more beautiful then alert. There will be a button
    # to reload app. Not even think about auto reloading, very dangerous.
    alert 'Application error. Sorry for that. Please reload browser.'

    if @reporter
      @reporter.setAdditionalArguments action: action

    # Don't swallow errors. For example este.Router uses .then for url update.
    throw reason
