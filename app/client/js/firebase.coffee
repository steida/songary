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
    @type {boolean}
    @private
  ###
  isLocalChange_: false

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
    @userRef.on 'value',
      (snap) =>
        # Ignore local changes. Workaround for nasty Firebase behavior.
        return if @isLocalChange_
        # Merge server changes to client.
        console.log snap.val()
        @userStore.updateFromServer user, snap.val()
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
    @param {Object} user
    @return {Firebase}
    @protected
  ###
  userRefOf: (user) ->
    @root
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
    @param {function(this:app.Firebase)} callback
  ###
  sync: (callback) ->
    @isLocalChange_ = true
    try
      # Callback immediately invokes @userRef.on handler.
      callback.call @
    finally
      @isLocalChange_ = false
