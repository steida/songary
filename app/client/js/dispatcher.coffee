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
    @type {number}
    @private
  ###
  pendingId_: 0

  ###*
    @type {Object}
    @private
  ###
  dependingIds_: null

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
    @assertCallbackId_ id
    delete @callbacks_[id]

  ###*
    Assert callback ID refers to registered callback.
    @param {number} id
    @private
  ###
  assertCallbackId_: (id) ->
    goog.asserts.assertFunction @callbacks_[id],
      "#{id} does not map to a registered callback."

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
    @dependingIds_ = {}
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
    @callbacks_.forEach (callback, id) =>
      # New promise to handle:
      #   1) sync callback returning something or nothing
      #   2) sync callback throwing error
      #   3) async callback returing promise
      new goog.Promise (resolve, reject) =>
        @pendingId_ = id
        resolve callback action, payload
      .then (value) =>
        @resolves_[id] payload
      .thenCatch (reason) =>
        if @errorReporter
          @errorReporter.report reason, action
        @rejects_[id] reason

  ###*
    @param {Array.<number>} ids Register callbacks IDs.
    @return {!goog.Promise}
  ###
  waitFor: (ids) ->
    goog.asserts.assert @isDispatching_, 'Must be invoked while dispatching.'
    goog.asserts.assertArray ids

    dependency = @detectCircularDependency_ @pendingId_, ids, []
    goog.asserts.assert !dependency.length,
      "Circular dependency detected: #{dependency.join ' - '}"
    @dependingIds_[@pendingId_] = ids

    goog.Promise.all ids.map (id) =>
      @assertCallbackId_ id
      @promises_[id]

  ###*
    @param {number} id
    @param {Array.<number>} deps
    @param {Array.<number>} list
    @return {Array.<number>} dependency Detected circular dependency.
    @private
  ###
  detectCircularDependency_: (id, deps, list) ->
    list.push id
    for depId in deps || []
      if depId == @pendingId_
        return list.concat depId
      dependency = @detectCircularDependency_ depId, @dependingIds_[depId], list.slice 0
      if dependency.length
        return dependency
    []
