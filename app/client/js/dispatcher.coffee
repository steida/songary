goog.provide 'app.Dispatcher'

goog.require 'goog.Promise'

class app.Dispatcher

  ###*
    http://facebook.github.io/flux/docs/todo-list.html#creating-a-dispatcher
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
    @param {Function} callback
    @return {number}
  ###
  register: (callback) ->
    @callbacks_.push callback
    @callbacks_.length - 1

  ###*
    @param {string} action
    @param {Object=} payload The data from the action.
    @return {!goog.Promise}
  ###
  dispatch: (action, payload) ->
    resolves = []
    rejects = []

    @promises_ = @callbacks_.map (callback, i) ->
      new goog.Promise (resolve, reject) ->
        resolves[i] = resolve
        rejects[i] = reject
        return

    @callbacks_.forEach (callback, i) =>
      goog.Promise.resolve callback action, payload
        .then (value) =>
          resolves[i] payload
        .thenCatch (reason) =>
          @error.handle reason, action
          rejects[i] reason

    goog.Promise.all @promises_

  ###*
   @param {Array.<number>} indexes
   @return {!goog.Promise}
  ###
  waitFor: (indexes) ->
    promises = indexes.map (index) => @promises_[index]
    goog.Promise.all promises
