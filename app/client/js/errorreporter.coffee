goog.provide 'app.ErrorReporter'

goog.require 'goog.Promise'
goog.require 'goog.debug.ErrorReporter'

class app.ErrorReporter

  ###*
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (@routes, @userStore) ->
    @alreadyReported_ = Object.create null

    if !goog.DEBUG
      @reporter = goog.debug.ErrorReporter.install @routes.api.clientErrors.url()

  ###*
    @param {*} reason
    @param {string} action
  ###
  report: (reason, action) ->
    # Cancellation is not considered as a real error. For example, este.Router
    # cancels loading when another route is requested before previous is done.
    if reason instanceof goog.Promise.CancellationError
      return

    # Don't report already reported reason.
    reasonAsString = reason.toString()
    return if @alreadyReported_[reasonAsString]
    @alreadyReported_[reasonAsString] = true

    if reason instanceof app.Xhr.OfflineError
      alert reason.message
      return

    # TODO: Show something more beautiful then alert with a button to reload
    # app. No, auto-reload isn't a good idea since it can cause looping.
    alert 'Application error. Please reload browser.'

    if @reporter
      @reporter.setAdditionalArguments
        action: action
        user: @userStore?.user?.displayName || ''

    # Don't swallow error since it can be handled by any other promise.
    # Throw also ensures error is shown in console and therefore catched by
    # goog.debug.ErrorReporter.
    throw reason
