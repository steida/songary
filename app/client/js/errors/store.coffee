goog.provide 'app.errors.Store'

goog.require 'app.errors.Error'
goog.require 'este.Store'
goog.require 'goog.Promise'
goog.require 'goog.array'
goog.require 'goog.async.throwException'
goog.require 'goog.debug.ErrorReporter'
goog.require 'goog.labs.net.xhr.Error'
goog.require 'goog.string'

class app.errors.Store extends este.Store

  ###*
    @param {app.Routes} routes
    @param {app.users.Store} usersStore
    @param {este.Dispatcher} dispatcher
    @constructor
    @extends {este.Store}
  ###
  constructor: (@routes, @usersStore, dispatcher) ->
    super()

    ###*
      @type {Object<string, Array>} Key is action, value is array of rejections.
      @private
    ###
    @errors_ = {}

    ###*
      @type {goog.debug.ErrorReporter}
      @private
    ###
    @reporter_ = goog.debug.ErrorReporter.install @routes.api.clientErrors.url()

    ###*
      Should be set after login and deleted before logout.
      @type {string}
    ###
    @userName = ''

    goog.Promise.setUnhandledRejectionHandler @unhandledRejectionHandler_.bind @

    dispatcher.onError = (action, reason) =>
      @errors_[action] ?= []
      @errors_[action].push reason

  ###*
    @param {*} reason
    @private
  ###
  unhandledRejectionHandler_: (reason) ->
    action = @findAction_ reason
    message = @getMessage_ action

    # TODO: Use React instead of alert.
    alert message

    debugger
    if @shouldNotBeReported_ reason
      console.log action, @errors_
    else
      @reporter_.setAdditionalArguments
        'action': action
        'errors': @errors_
        'userName': @usersStore.user?.name
      # Throw exception async to be caught by goog.debug.ErrorReporter without
      # interrupting current dispatching.
      goog.async.throwException reason
    @errors_ = {}

  ###*
    @param {*} reason
    @return {string}
    @private
  ###
  findAction_: (reason) ->
    for action, reasons of @errors_
      if goog.array.contains reasons, reason
        return action
    ''

  ###*
    @param {string} action
    @return {string}
    @private
  ###
  getMessage_: (action) ->
    reasons = @errors_[action].join ', '
    Store.MSG_APP_ERROR = goog.getMsg 'Action {$action} failed because:
      "{$reasons}". Sorry for that, please reload browser.'
    ,
      'action': action
      'reasons': reasons
    # TODO: Remove once alert is replaced with React.
    goog.string.normalizeWhitespace Store.MSG_APP_ERROR

  ###*
    @param {*} reason
    @return {boolean}
    @private
  ###
  shouldNotBeReported_: (reason) ->
    reason instanceof app.errors.Error ||
    reason instanceof goog.labs.net.xhr.Error
