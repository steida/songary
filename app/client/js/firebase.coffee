goog.provide 'app.Firebase'

goog.require 'goog.asserts'

class app.Firebase

  ###*
    @constructor
  ###
  constructor: ->
    @setFireBaseRefs()

  ###*
    @type {Firebase}
  ###
  userRef: null

  ###*
    @protected
  ###
  setFireBaseRefs: ->
    # TODO(steida): Use server data for path, make it isomorphic.
    return if !window.Firebase
    @root = new window.Firebase 'https://shining-fire-6810.firebaseio.com/'

  ###*
    @param {app.user.Store} userStore
  ###
  simpleLogin: (userStore) ->
    goog.asserts.assert !@authClient, 'Can be called only once'
    @authClient = new window.FirebaseSimpleLogin @root, @onSimpleLogin.bind @, userStore

  ###*
    NOTE(steida): This method is called whenever user login status has changed.
    TODO(steida): Refactor.
    @param {app.user.Store} userStore
    @param {Object} error
    @param {Object} user
  ###
  onSimpleLogin: (userStore, error, user) ->
    if error
      # TODO(steida): Report to server.
      console.log error
      return

    # TODO(steida): Refactor it.
    if !user
      # NOTE(steida): Stop listening changes after logout.
      # @stopListeningUserValue()
      @userRef?.off 'value'
      # PATTERN(steida): Logout deletes all user data in local storage.
      # TODO(steida): This should belong into userStore.
      if @userRef
        userStore.setEmpty()
      else
        userStore.user = null
      userStore.notify()
      # TODO(steida): Redirect to home.
      return

    @userRef = @userRefOf user

    # NOTE(steida): Would be nice to get all data in one request. RavenDB include ftw.
    # TODO(steida): Use more granular approach.
    @userRef.on 'value',
      (snap) =>
        # NOTE(steida): For not yet persisted user, snap.val() is null.
        storeJson = snap.val() ? userStore.toJson()
        storeJson.user = user
        userStore.fromJson storeJson
        userStore.notify()
    , (error) ->
      # TODO(steida): Report to server.
      console.log 'The read failed: ' + error.code

  ###*
    @param {Object} user
    @return {Firebase}
  ###
  userRefOf: (user) ->
    @root
      .child 'users'
      .child user.uid

  loginViaFacebook: ->
    @authClient.login 'facebook',
      rememberMe: true
      # TODO(steida): user_likes
      scope: 'email'

  logout: ->
    @authClient.logout()