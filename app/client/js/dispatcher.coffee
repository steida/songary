goog.provide 'app.Dispatcher'

goog.require 'goog.Promise'
goog.require 'goog.asserts'

class app.Dispatcher

  ###*
    Inspired by facebook.github.io/flux/docs/todo-list.html#creating-a-dispatcher
    and https://github.com/facebook/flux/blob/master/dist/Flux.js.
    @param {app.ErrorReporter=} errorReporter
    @constructor
    @final
  ###
  constructor: (@errorReporter) ->
    ###*
      @type {Array.<Function>}
      @private
    ###
    @callbacks_ = []

  ###*
    @type {boolean}
    @private
  ###
  @isDispatching_: false

  ###*
    @type {Array.<goog.Promise>}
    @private
  ###
  @resolves_: null

  ###*
    @type {Array.<goog.Promise>}
    @private
  ###
  @rejects_: null

  ###*
    @type {Array.<goog.Promise>}
    @private
  ###
  @promises_: null

  ###*
    @param {Function} callback
    @return {number} ID of registered callback.
  ###
  register: (callback) ->
    goog.asserts.assertFunction callback
    @callbacks_.push(callback) - 1

  ###*
    @param {number} id ID of registered callback.
  ###
  unregister: (id) ->
    # goog.asserts.assertFunction callback
    goog.asserts.assertFunction @callbacks_[id],
      "`#{id}` does not map to a registered callback."
    delete @callbacks_[id]

  ###*
    @param {string} action
    @param {Object=} payload Data for action.
    @return {!goog.Promise}
  ###
  dispatch: (action, payload) ->
    goog.asserts.assert !@isDispatching_,
      'Cannot dispatch in the middle of a dispatch.'
    goog.asserts.assertString action
    goog.asserts.assertObject payload

    @isDispatching_ = true
    @resolves_ = []
    @rejects_ = []
    @createPromisesForCallbacks_()
    @runCallbacks_ action, payload
    @isDispatching_ = false
    goog.Promise.all @promises_

  ###*
    @private
  ###
  createPromisesForCallbacks_: ->
    @promises_ = @callbacks_.map (callback, i) =>
      new goog.Promise (resolve, reject) =>
        @resolves_[i] = resolve
        @rejects_[i] = reject
        return

  ###*
    @param {string} action
    @param {Object=} payload Data for action.
    @private
  ###
  runCallbacks_: (action, payload) ->
    @callbacks_.forEach (callback, i) =>
      # New promise to handle:
      #   1) sync callback returning nothing
      #   2) callback throwing error
      #   3) async callback returing promise
      new goog.Promise (resolve, reject) =>
        resolve callback action, payload
      .then (value) =>
        @resolves_[i] payload
      .thenCatch (reason) =>
        if @errorReporter
          @errorReporter.report reason, action
        @rejects_[i] reason

  ###*
    @param {Array.<number>} ids IDs of register method.
    @return {!goog.Promise}
  ###
  waitFor: (ids) ->

    # co async? smrt, ani nahodou, sileny na debug, proste musim vedet, odkud volam
    # wait for
    # a na d, e
    #

    goog.asserts.assert @isDispatching_, 'Must be invoked while dispatching.'
    goog.asserts.assertArray ids

    goog.Promise.all ids.map (id) =>
      goog.asserts.assertFunction @callbacks_[id],
        "`#{id}` does not map to a registered callback."
      # Circular dependency detected for:
      @promises_[id]
