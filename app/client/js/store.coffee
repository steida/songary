goog.provide 'app.Store'

goog.require 'goog.array'
goog.require 'goog.events.EventTarget'

class app.Store extends goog.events.EventTarget

  ###*
    TODO(steida): Wait to be stabilized, then move to este-library.
    @param {string} name
    @constructor
    @extends {goog.events.EventTarget}
  ###
  constructor: (name) ->
    super()

    ###*
      @const
      @type {string}
    ###
    @name = name

  ###*
    @return {Object}
  ###
  toJson: goog.abstractMethod

  ###*
    @param {Object} json
  ###
  fromJson: goog.abstractMethod

  ###*
    @param {Function} constructor
    @param {Object=} json
    @return {*}
  ###
  instanceFromJson: (constructor, json) ->
    if arguments.length == 2
      instance = new constructor
      goog.mixin instance, json || {}
      return instance
    (json) =>
      @instanceFromJson constructor, json

  ###*
    PATTERN(steida): Whenever store changes anything, just call notify to
    dispatch change event.
  ###
  notify: ->
    @dispatchEvent 'change'