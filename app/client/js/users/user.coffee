goog.provide 'app.users.User'

class app.users.User

  ###*
    @param {Object=} json
    @constructor
  ###
  constructor: (json) ->
    goog.mixin @, json if json

  ###*
    @param {Object} json
    @return {app.users.User}
  ###
  @fromFacebook: (json) ->
    new app.users.User
      email: json.email
      id: 'facebook:' + json.id
      name: json.name
      providers: facebook: json

  ###*
    @type {string}
  ###
  email: ''

  ###*
    @type {string}
  ###
  id: ''

  ###*
    @type {string}
  ###
  name: ''

  ###*
    @type {Object}
  ###
  provider: null
