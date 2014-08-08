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
    @type {boolean}
  ###
  userWasLogged: false

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
    @param {app.user.Store} userStore
    @param {Object} error
    @param {Object} user
  ###
  onSimpleLogin: (userStore, error, user) ->
    if error
      # TODO(steida): Report to server.
      console.log error
      return

    if !user
      # NOTE(steida): Stop listening changes after logout.
      @userRef?.off 'value'
      # PATTERN(steida): Logout deletes all user data in local storage.
      if @userWasLogged
        userStore.setEmpty()
      userStore.notify()
      # TODO(steida): Redirect to home.
      return

    @userWasLogged = true
    @userRef = @userRefOf user

    # NOTE(steida): Would be nice to get all data in one request. RavenDB include ftw.
    # TODO(steida): Use more granular approach to save traffic.
    @userRef.on 'value',
      (snap) =>
        if goog.DEBUG
          console.log 'On userRef value.'
        # NOTE(steida): For not yet persisted user, snap.val() is null.
        # PATTERN(steida): Project updates only into store. Store dispatches change
        # event, and then app.Storage will decide how store should be persisted.
        storeJson = snap.val() ? userStore.toJson()
        storeJson.user = user
        # previous = JSON.stringify userStore.toJson()
        # console.log previous, previous
        # return if previous == JSON.stringify storeJson
        userStore.fromJson storeJson
        userStore.silentNotify()
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