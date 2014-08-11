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
    # TODO(steida): Use server data for path, make it isomorphic.
    return if !window.Firebase
    @root = new window.Firebase 'https://shining-fire-6810.firebaseio.com/'

  ###*
    # TODO(steida): Do it on server side. It takes seconds on client.
  ###
  simpleLogin: ->
    # TODO(steida): Make it isomorphic.
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
    # TODO(steida): Report to server.
    console.log error

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
    @param {Object} user Firebase user. NOTE(steida): Now user is always stored,
    to be readonly. Later it will be customizable.
    @protected
  ###
  listenUserRefValue: (user) ->
    @userRef?.on 'value',
      (snap) =>
        console.log "on @userRef.on 'value',"
        @userStore.updateFromServer user, snap.val()
    , (error) ->
      # TODO(steida): Report to server.
      console.log 'The read failed: ' + error.code

  onUserLogout: ->
    @userRef?.off 'value'
    @userStore.onLogout !!@userRef

  loginViaFacebook: ->
    @authClient.login 'facebook',
      rememberMe: true
      # TODO(steida): user_likes
      scope: 'email'

  logout: ->
    @authClient.logout()