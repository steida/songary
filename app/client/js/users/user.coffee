goog.provide 'app.users.User'

class app.users.User

  ###*
    @constructor
  ###
  constructor: ->

  ###*
    ID is an empty string until first sync.
    @type {string}
    @expose
  ###
  id: ''

  ###*
    ISO 8601 string representation of date/time.
    @type {string}
    @expose
  ###
  created: ''

  ###*
    ISO 8601 string representation of date/time.
    @type {string}
    @expose
  ###
  updated: ''

  ###*
    @type {string}
    @expose
  ###
  email: ''