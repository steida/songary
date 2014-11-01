goog.provide 'app.facebook.Store'

class app.facebook.Store

  ###*
    @param {app.Dispatcher} dispatcher
    @param {app.users.Store} usersStore
    @constructor
  ###
  constructor: (dispatcher, @usersStore) ->
    dispatcher.register (action, payload) =>
      switch action
        when app.Actions.LOGIN
          @login_()
        when app.Actions.LOGOUT
          @logout_()
  ###*
    @type {Object}
    @private
  ###
  fb_: null

  ###*
    Load Facebook api async.
  ###
  init: ->
    # window.fbAsyncInit = =>
    #   @fb_ = window.FB
    #   @fb_.init
    #     'appId': '1458272837757905'
    #     'cookie': true
    #     'version': 'v2.1'
    #     'xfbml': false
    #
    # # Load the SDK asynchronously.
    # ((d, s, id) ->
    #   fjs = d.getElementsByTagName(s)[0]
    #   return if d.getElementById id
    #   js = d.createElement s
    #   js.id = id
    #   js.src = '//connect.facebook.net/en_US/sdk.js'
    #   fjs.parentNode.insertBefore js, fjs
    #   return
    # ) document, 'script', 'facebook-jssdk'

  ###*
    TODO: Use FB.login with promise.
    @private
  ###
  login_: ->
    if !@fb_
      alert 'Facebook API not ready yet. Click again please.'
      return
    @getLoginStatus_()
      .then => @onConnected_()

  ###*
    @private
  ###
  getLoginStatus_: ->
    new goog.Promise (resolve, reject) =>
      @fb_.getLoginStatus (response) =>
        if response.status == 'connected'
          resolve()
        else if response.status == 'not_authorized'
          alert 'Please log into this app.'
          reject()
        else
          alert 'Please log into Facebook.'
          reject()

  ###*
    @private
  ###
  logout_: ->
    # The FB.logout log the person out of Facebook, which is not we want.
    @usersStore.logout()

  ###*
    @private
  ###
  onConnected_: ->
    @fb_.api '/me', (response) =>
      @usersStore.loginFacebookUser response
