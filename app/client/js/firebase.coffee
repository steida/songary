goog.provide 'app.Firebase'

goog.require 'goog.asserts'

class app.Firebase

  ###*
    Firebase wrapper for app. Remember, app has to always work without Firebase
    and be able to switch Firebase for something else anytime.
    @param {app.user.Store} userStore
    @constructor
    @final
  ###
  constructor: (@userStore) ->
    @setRefs_()

  ###*
    @type {Firebase}
  ###
  rootRef: null

  ###*
    @type {Firebase}
  ###
  userRef: null

  ###*
    @type {boolean}
    @private
  ###
  isLocalChange_: false

  ###*
    @private
  ###
  setRefs_: ->
    # TODO: Use server data for path, make it isomorphic.
    return if !window.Firebase
    @rootRef = new window.Firebase 'https://shining-fire-6810.firebaseio.com/'

  ###*
    TODO: Do it on server side.
  ###
  simpleLogin: ->
    # TODO: Make it isomorphic.
    return if !window.FirebaseSimpleLogin
    goog.asserts.assert !@authClient
    @authClient = new window.FirebaseSimpleLogin @rootRef, @onSimpleLogin.bind @

  ###*
    This method is called whenever user login status has changed. Unfortunatelly
    it does not report change across browser tabs/windows.
    @param {Object} error
    @param {Object} user
    @private
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
    @private
  ###
  onUserError: (error) ->
    # TODO: Report to server.
    throw error if goog.DEBUG

  ###*
    @param {Object} user Firebase user.
    @private
  ###
  onUserLogin: (user) ->
    @userRef = @userRefOf user
    @setUserLastOnlineOnDisconnect_()
    @listenServerChanges_ user

  ###*
    @private
  ###
  setUserLastOnlineOnDisconnect_: ->
    @userRef.child('user/lastOnline')
      .onDisconnect()
      .set window.Firebase.ServerValue.TIMESTAMP

  ###*
    @param {Object} user Firebase user.
    @private
  ###
  listenServerChanges_: (user) ->
    userJustLogged = true
    @userRef.on 'value', (snap) =>
      return if @isLocalChange_
      console.log 'onServerValue'
      val = snap.val()

      serverUserExists = val?.user?.uid
      if !serverUserExists
        @saveNewUser user
        return

      @userStore.fromJson val

      if userJustLogged
        userJustLogged = false
        # Plain notify to sync local changes to server after user login.
        @userStore.notify()
      else
        @userStore.notify @

    , (error) ->
      # TODO: Report to server.
      if goog.DEBUG
        console.log 'The read failed: ' + error.code

  ###*
    @param {Object} user Firebase user.
    @private
  ###
  saveNewUser: (user) ->
    user = @userStore.authUserToAppUser user
    # This will invoke server response as TIMESTAMP will be replaced.
    user.createdAt = window.Firebase.ServerValue.TIMESTAMP
    @userRef.set user: user

  ###*
    @param {Object} user
    @return {Firebase}
    @private
  ###
  userRefOf: (user) ->
    @rootRef
      .child 'users'
      .child user.uid

  onUserLogout: ->
    userWasLogged = !!@userRef
    @userRef.off 'value' if userWasLogged
    @userRef = null
    ###*
      PATTERN: Logout has to delete all data in memory and in localStorage, but
      only if user was logged before. We don't want to delete data for not yet
      registered/logged user.
    ###
    @userStore.clearOnLogout userWasLogged
    @userStore.notify @

  loginViaFacebook: ->
    @authClient.login 'facebook',
      rememberMe: true
      # TODO: Use user_likes.
      scope: 'email'

  logout: ->
    @authClient.logout()

  ###*
    Use this method for any Firebase state changing method. It temporally
    disables local change propagation. Firebase by default calls listeners
    immediatelly after any set/update. This hack allows us to bypass this IMHO
    wrong behavior.
    As result, Firebase.ServerValue.TIMESTAMP isn't immediatelly propagated to
    local state. If you need immediate propagation, use your own local time
    implementation in store.
    In near time, Firebase will be moved to server and this issue disappear.
    @param {function(this:app.Firebase)} callback
  ###
  sync: (callback) ->
    @isLocalChange_ = true
    try
      # Callback immediately invokes @userRef.on handler.
      callback.call @
    finally
      @isLocalChange_ = false

  ###*
    @param {string} uid
    @param {string} displayName
    @param {string} message
  ###
  sendContactFormMessage: (uid, displayName, message) ->
    @rootRef
      .child 'contactFormMessages'
      .push
        uid: uid
        displayName: displayName
        message: message
