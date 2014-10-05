goog.provide 'app.Error'

goog.require 'goog.Promise'
goog.require 'goog.debug.ErrorReporter'

class app.Error

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
  handle: (reason, action) ->
    # Cancellation is not considered as a real error. For example, este.Router
    # cancels loading when another route is requested before previous is done.
    if reason instanceof goog.Promise.CancellationError
      return

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
      @reporter.setAdditionalArguments
        action: action
        user: @userStore?.user?.displayName || ''

    # Don't swallow errors. It can be handled in some other promise, for example
    # in este.Router. Also it's good to see error in console. Therefore
    # ErrorReporter can report it to server.
    throw reason
