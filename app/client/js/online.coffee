goog.provide 'app.Online'

class app.Online

  ###*
    @constructor
  ###
  constructor: ->

  ###*
    @return {boolean} True if browser is online.
  ###
  check: ->
    return true if navigator.onLine
    alert Online.MSG_MUST_BE_ONLINE
    false

  @MSG_MUST_BE_ONLINE: goog.getMsg 'You must be online. Check your internet connection please.'
