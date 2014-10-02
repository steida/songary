goog.provide 'app.Dispatcher'

goog.require 'goog.Promise'
goog.require 'goog.asserts'

class app.Dispatcher

  ###*
    http://facebook.github.io/flux/docs/todo-list.html#creating-a-dispatcher
    TODO: Detect circular dependencies.
    TODO: Move to este-library once finish.
    @param {app.Error} error
    @constructor
    @final
  ###
  constructor: (@error) ->
    ###*
      @type {Array.<Function>}
      @private
    ###
    @callbacks_ = []

    ###*
      @type {Array.<goog.Promise>}
      @private
    ###
    @promises_ = null

    ###*
      @type {boolean}
      @private
    ###
    @isDispatching_ = false

  ###*
    @param {Function} callback
    @return {number}
  ###
  register: (callback) ->
    goog.asserts.assertFunction callback
    @callbacks_.push callback
    @callbacks_.length - 1

  ###*
    @param {number} index
  ###
  unregister: (index) ->
    # goog.asserts.assertFunction callback
    goog.asserts.assertFunction @callbacks_[index],
      "`#{index}` does not map to a registered callback."
    delete @callbacks_[index]

  ###*
    @param {string} action
    @param {Object=} payload The data from the action.
    @return {!goog.Promise}
  ###
  dispatch: (action, payload) ->
    goog.asserts.assert !@isDispatching_,
      'Cannot dispatch in the middle of a dispatch.'
    goog.asserts.assertString action
    goog.asserts.assertObject payload

    resolves = []
    rejects = []

    @promises_ = @callbacks_.map (callback, i) ->
      new goog.Promise (resolve, reject) ->
        resolves[i] = resolve
        rejects[i] = reject
        return

    @isDispatching_ = true
    @callbacks_.forEach (callback, i) =>
      goog.Promise.resolve callback action, payload
        .then (value) =>
          resolves[i] payload
        .thenCatch (reason) =>
          rejects[i] reason
          @error.handle reason, action
    @isDispatching_ = false

    goog.Promise.all @promises_

  ###*
   @param {Array.<number>} indexes
   @return {!goog.Promise}
  ###
  waitFor: (indexes) ->
    goog.asserts.assertArray indexes
    goog.asserts.assert @isDispatching_, 'Must be invoked while dispatching.'
    for index in indexes
      goog.asserts.assertFunction @callbacks_[index],
        "`#{index}` does not map to a registered callback."

    # `%s` does not map to a registered callback.'
    promises = indexes.map (index) => @promises_[index]
    goog.Promise.all promises
