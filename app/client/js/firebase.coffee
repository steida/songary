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
    userJustLogged = true
    # The problem with Firebase on 'value' is, that this method is dispatched
    # two times when Firebase.ServerValue.TIMESTAMP is used.
    # 1. locally made change
    # 2. server with updated TIMESTAMP value.
    @userRef.on 'value',
      (snap) =>
        # Can be null for new users.
        val = snap.val()
        # This check is used to ignore local Firebase changes.
        # TODO: Consider splitting to localUpdated and serverUpdated.
        return if val && val.updated == @userStore.updated
        # Merge server changes to local.
        @userStore.updateFromServer user, val
        if userJustLogged
          userJustLogged = false
          # Notify will rerun sync to server, so local changes made before login
          # will be saved.
          @userStore.notify()
        else
          # User is already loged, to we need only to save server changes.
          @userStore.serverNotify()

    , (error) ->
      # TODO: Report to server.
      if goog.DEBUG
        console.log 'The read failed: ' + error.code

  ###*
    @param {Object} user
    @return {Firebase}
    @protected
  ###
  userRefOf: (user) ->
    @root
      .child 'users'
      .child user.uid

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
