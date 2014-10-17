goog.provide 'app.ErrorReporter'

goog.require 'goog.Promise'
goog.require 'goog.debug.ErrorReporter'
goog.require 'app.Xhr.OfflineError'
goog.require 'goog.net.HttpStatus'

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
    @param {string} action
    @param {*} reason
  ###
  report: (action, reason) ->
    return if !@isWorthReport_ reason

    # TODO: Show something more beautiful then alert. Add button to reload app.
    # Auto-reload is bad idea because it can cause reload looping.
    alert 'Application error. Please reload browser.'

    if !@isAlreadyReported_ reason
      @reporter?.setAdditionalArguments
        action: action
        user: @userStore?.user?.displayName || ''

      # Propagate error to other promises. It also ensures reason is shown in
      # console therefore catched and reported by goog.debug.ErrorReporter.
      throw reason

  ###*
    @param {*} reason
    @return {boolean}
  ###
  isWorthReport_: (reason) ->
    # 404 is common.
    return false if reason == 404
    # Cancellation is ok. For example este.Router cancels aborted requests.
    return false if reason instanceof goog.Promise.CancellationError
    # User is offline. It happens.
    if reason instanceof app.Xhr.OfflineError
      alert reason.message
      return false
    true

  ###*
    Don't report already reported reason.
    @param {*} reason
    @return {boolean}
  ###
  isAlreadyReported_: (reason) ->
    stringReason = String reason
    if @alreadyReported_[stringReason]
      return true
    @alreadyReported_[stringReason] = true
    false
