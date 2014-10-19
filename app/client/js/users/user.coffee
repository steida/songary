goog.provide 'app.User'

class app.User

  ###*
    @param {Object=} json
    @constructor
  ###
  constructor: (json) ->
    goog.mixin @, json if json

  ###*
    @param {Object} json
    @return {app.User}
  ###
  @fromFacebook: (json) ->
    new app.User
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
