goog.provide 'app.Store'

goog.require 'este.labs.Store'
goog.require 'goog.net.HttpStatus'

class app.Store extends este.labs.Store

  ###*
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: ->
    super 'app'

  ###*
    @type {number}
  ###
  httpStatus: goog.net.HttpStatus.OK