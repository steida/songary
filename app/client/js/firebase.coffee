goog.provide 'app.Firebase'

goog.require 'goog.asserts'

class app.Firebase

  ###*
    @constructor
  ###
  constructor: ->
    @setFireBaseRefs()

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
      # PATTERN(steida): Logout has to delete all user specific data.
      userStore.setUser null
      return

    # NOTE(steida): Would be nice to get all data in one request. RavenDB include ftw.
    userRef = @userRefOf user

    # TODO(steida): Use more granular approach to save traffic.
    userRef.once 'value',
      (snap) ->
        serverUser = snap.val()
        console.log serverUser
        # PATTERN(steida): Project updates only into store. Store dispatches change
        # event, and app.Storage will decide how store should be persisted.
        userStore.setUser user
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