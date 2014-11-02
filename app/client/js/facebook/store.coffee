goog.provide 'app.facebook.Store'
goog.provide 'app.facebook.Store.LoginError'

goog.require 'app.errors.InnocuousError'

class app.facebook.Store

  ###*
    Note FB.logout is not used, because it logout user out of Facebook entirely.
    Also FB.getLoginStatus is not used, because loginStatus is handled by app.
    User login status is persisted in localStorage via usersStore.
    @param {app.Dispatcher} dispatcher
    @constructor
  ###
  constructor: (dispatcher) ->
    @dispatcherId = dispatcher.register (action, payload) =>
      switch action
        when app.Actions.LOGIN then @login_()

  ###*
    Facebook me user data.
    @type {Object}
  ###
  me: null

  ###*
    @type {Object}
    @private
  ###
  fb_: null

  ###*
    Load Facebook api async.
  ###
  init: ->
    window.fbAsyncInit = =>
      @fb_ = window.FB
      @fb_.init
        'appId': '1458272837757905'
        'cookie': true
        'version': 'v2.1'
        'xfbml': false

    ((d, s, id) ->
      fjs = d.getElementsByTagName(s)[0]
      return if d.getElementById id
      js = d.createElement s
      js.id = id
      js.src = '//connect.facebook.net/en_US/sdk.js'
      fjs.parentNode.insertBefore js, fjs
      return
    ) document, 'script', 'facebook-jssdk'

  ###*
    @private
  ###
  login_: ->
    if !@fb_
      error = new app.errors.InnocuousError "Facebook API not ready yet. Click
        again please."
      return goog.Promise.reject error
    @loginAsync_()
      .then (response) => @getMeAsync_()
      .then (me) => @me = me

  ###*
    @private
  ###
  loginAsync_: ->
    new goog.Promise (resolve, reject) =>
      @fb_.login (response) ->
        if response.status == 'connected'
          resolve response
        else
          reject new app.facebook.Store.LoginError response.status
      , scope: 'public_profile,email,user_friends'

  ###*
    @private
  ###
  getMeAsync_: ->
    new goog.Promise (resolve, reject) =>
      @fb_.api '/me', (response) ->
        if response && !response.error
          resolve response
        else
          reject new app.facebook.Store.LoginError response?.error

class app.facebook.Store.LoginError extends app.errors.InnocuousError

  ###*
    @param {string} responseStatus
    @constructor
    @extends {app.errors.InnocuousError}
  ###
  constructor: (responseStatus) ->
    msg = switch responseStatus
      when 'not_authorized'
        'Please log into this app.'
      else
        'Please log into Facebook.'
    super msg
