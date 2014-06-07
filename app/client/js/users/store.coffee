goog.provide 'app.users.Store'

goog.require 'app.users.User'
goog.require 'goog.date.UtcDateTime'

class app.users.Store

  ###*
    @constructor
  ###
  constructor: ->

  ###*
    @return {app.users.User}
    @private
  ###
  create: ->
    user = new app.users.User
    now = new goog.date.UtcDateTime().toIsoString()
    user.updated = user.created = now
    user