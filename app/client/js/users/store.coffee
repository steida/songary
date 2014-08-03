goog.provide 'app.users.Store'

goog.require 'app.users.User'
goog.require 'goog.date.UtcDateTime'

class app.users.Store

  ###*
    @param {app.Firebase} firebase
    @constructor
  ###
  constructor: (@firebase) ->
    # Anonymous?
    # @firebase.initSimpleLogin (error, user) =>
    #   # console.log '@firebase.initSimpleLogin'
    #   if error
    #     console.log error
    #   else if user
    #     @user = user

  ###*
    @type {Object}
  ###
  user: null

  ###*
    @return {boolean}
  ###
  isLogged: -> !!@user

  logout: ->
    @firebase.authClient.logout()
    @user = null

  loginViaFacebook: ->
    @firebase.authClient.login 'facebook',
      rememberMe: true
      # TODO(steida): user_likes
      scope: 'email'

  # ###*
  #   @return {app.users.User}
  #   @private
  # ###
  # create: ->
  #   user = new app.users.User
  #   now = new goog.date.UtcDateTime().toIsoString()
  #   user.updated = user.created = now
  #   user