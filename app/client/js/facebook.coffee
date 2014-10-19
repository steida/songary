goog.provide 'app.Facebook'

class app.Facebook

  ###*
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (@userStore) ->

  ###*
    @type {Object}
    @private
  ###
  fb_: null

  ###*
    Enable Facebook api.
  ###
  init: ->
    window.fbAsyncInit = =>
      @fb_ = window.FB
      @fb_.init
        'appId': '1458272837757905'
        'cookie': false
        'version': 'v2.1'
        'xfbml': false

    # Load the SDK asynchronously.
    ((d, s, id) ->
      fjs = d.getElementsByTagName(s)[0]
      return if d.getElementById id
      js = d.createElement s
      js.id = id
      js.src = '//connect.facebook.net/en_US/sdk.js'
      fjs.parentNode.insertBefore js, fjs
      return
    ) document, 'script', 'facebook-jssdk'

  login: ->
    if !@fb_
      alert 'Facebook API not ready yet. Click again please.'
      return
    @fb_.getLoginStatus (response) =>
      if response.status == 'connected'
        @onConnected_()
      else if response.status == 'not_authorized'
        alert 'Please log into this app.'
      else
        alert 'Please log into Facebook.'

  ###*
    @private
  ###
  onConnected_: ->
    @fb_.api '/me', (response) =>
      @userStore.loginFacebookUser response

  logout: ->
    # The FB.logout log the person out of Facebook, which is not we want.
    @userStore.logout()
