goog.provide 'app.Firebase'

goog.require 'goog.asserts'

class app.Firebase

  ###*
    @param {app.user.Store} userStore
    @constructor
  ###
  constructor: (@userStore) ->
    @setRefs()

  ###*
    @type {Firebase}
  ###
  userRef: null

  ###*
    @protected
  ###
  setRefs: ->
    # TODO: Use server data for path, make it isomorphic.
    return if !window.Firebase
    @root = new window.Firebase 'https://shining-fire-6810.firebaseio.com/'

  ###*
    # TODO: Do it on server side. It takes seconds on client.
  ###
  simpleLogin: ->
    # TODO: Make it isomorphic.
    return if !window.FirebaseSimpleLogin
    goog.asserts.assert !@authClient
    @authClient = new window.FirebaseSimpleLogin @root, @onSimpleLogin.bind @

  ###*
    This method is called whenever user login status has changed. Unfortunatelly
    it does not report change across browser tabs/windows.
    @param {Object} error
    @param {Object} user
    @protected
  ###
  onSimpleLogin: (error, user) ->
    if error
      @onUserError error
    else if user
      @onUserLogin user
    else
      @onUserLogout()

  ###*
    @param {Object} error Firebase error.
    @protected
  ###
  onUserError: (error) ->
    # TODO: Report to server.
    throw error if goog.DEBUG

  ###*
    @param {Object} user Firebase user.
    @protected
  ###
  onUserLogin: (user) ->
    @userRef = @userRefOf user
    @listenUserRefValue user

  ###*
    @param {Object} user
    @return {Firebase}
    @protected
  ###
  userRefOf: (user) ->
    @root
      .child 'users'
      .child user.uid

  ###*
    @param {Object} user Firebase user.
    @protected
  ###
  listenUserRefValue: (user) ->
    @userRef?.on 'value',
      (snap) =>
        if goog.DEBUG
          console.log "on @userRef.on 'value',"
        @userStore.updateFromServer user, snap.val()
    , (error) ->
      # TODO: Report to server.
      if goog.DEBUG
        console.log 'The read failed: ' + error.code

  onUserLogout: ->
    @userRef?.off 'value'
    @userStore.onLogout !!@userRef

  loginViaFacebook: ->
    @authClient.login 'facebook',
      rememberMe: true
      # TODO: Use user_likes.
      scope: 'email'

  logout: ->
    @authClient.logout()
