goog.provide 'app.facebook.Store'
goog.provide 'app.facebook.Store.LoginError'

goog.require 'app.errors.Error'
goog.require 'goog.labs.net.xhr'
goog.require 'goog.labs.userAgent.browser'
goog.require 'goog.labs.userAgent.platform'
goog.require 'goog.uri.utils'

class app.facebook.Store

  ###*
    Facebook login. Note FB.logout method isn't used, because it logouts user
    from Facebook entirely. FB.getLoginStatus isn't used also, because
    loginStatus is persisted in localStorage.
    @param {app.Actions} actions
    @param {este.Dispatcher} dispatcher
    @constructor
  ###
  constructor: (@actions, dispatcher) ->
    @dispatcherId = dispatcher.register (action, payload) =>
      switch action
        when app.Actions.LOGIN
          @login_()
        when app.Actions.LOGIN_FROM_FACEBOOK_REDIRECT
          @loginFromFacebookRedirect_ payload

  @FB_APP_ID: '1458272837757905'
  @FB_SCOPE: 'public_profile,email,user_friends'

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
  start: ->
    if @isIosChrome_()
      @handleManualLoginFlow_()

    window.fbAsyncInit = =>
      @fb_ = window.FB
      @fb_.init
        'appId': Store.FB_APP_ID
        'cookie': true
        'version': 'v2.2'
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
    @return {boolean}
    @private
  ###
  isIosChrome_: ->
    goog.labs.userAgent.browser.isChrome() &&
    goog.labs.userAgent.platform.isIos()

  ###*
    https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow/v2.2#login
    https://www.youtube.com/watch?v=i0zdxVaK59g
    @protected
  ###
  handleManualLoginFlow_: ->
    # Transform Facebook fragment querydata into querystring.
    uri = location.host + '?' + location.hash.slice 1

    loginCancelled =
      goog.uri.utils.hasParam(uri, 'error') ||
      goog.uri.utils.hasParam(uri, 'error_reason')
    if loginCancelled
      alert goog.uri.utils.getParamValue uri, 'error_description'
      @removeQuestionMarkWithHashWithoutReload_()
      return

    auth =
      accessToken: goog.uri.utils.getParamValue uri, 'access_token'
      expiresIn: Number goog.uri.utils.getParamValue uri, 'expires_in'
    isLogged = auth.accessToken && auth.expiresIn
    if isLogged
      @removeQuestionMarkWithHashWithoutReload_()
      @actions.loginFromFacebookRedirect auth

  ###*
    http://stackoverflow.com/a/13824103/233902
    TODO: If ok, move to este-library.
  ###
  removeQuestionMarkWithHashWithoutReload_: ->
    location.replace '#'
    window.history.replaceState {}, '', location.href.slice 0, -2

  ###*
    @private
  ###
  login_: ->
    if !@fb_
      error = new app.errors.Error "Facebook API not ready yet. Click
        again please."
      return goog.Promise.reject error

    if @isIosChrome_()
      redirectUrl = "https://m.facebook.com/dialog/oauth?client_id=#{Store.FB_APP_ID}&redirect_uri=#{location.href}&scope=#{Store.FB_SCOPE}&response_type=token"
      window.location = redirectUrl
      return goog.Promise.reject goog.net.HttpStatus.USE_PROXY

    @loginAsync_().then (response) =>
      @getMeAsync_().then (me) =>
        @setMe_ me,
          accessToken: response.authResponse.accessToken
          expiresIn: response.authResponse.expiresIn

  ###*
    @param {Object} me
    @param {Object} auth
    @private
  ###
  setMe_: (me, auth) ->
    @me = me
    @me.auth = auth

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
      , scope: Store.FB_SCOPE

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

  ###*
    @param {Object} auth
    @private
  ###
  loginFromFacebookRedirect_: (auth) ->
    uri = "https://graph.facebook.com/me?access_token=#{auth.accessToken}"
    goog.labs.net.xhr.getJson uri
      .then (me) => @setMe_ me, auth

class app.facebook.Store.LoginError extends app.errors.Error

  ###*
    @param {string} responseStatus
    @constructor
    @extends {app.errors.Error}
  ###
  constructor: (responseStatus) ->
    msg = switch responseStatus
      when 'not_authorized'
        'Please log into this app.'
      else
        'Please log into Facebook.'
    super msg
