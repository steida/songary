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
    @return {Function}
  ###
  instanceFromJson: (constructor, json) ->
    instance = new constructor
    if json
      goog.mixin instance, json
      return instance
    (json) ->
      goog.mixin instance, json
      instance

  ###*
    @protected
  ###
  notify: ->
    @dispatchEvent 'change'