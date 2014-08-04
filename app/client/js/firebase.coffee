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
    @authenticated = @root.child '.info/authenticated'

  ###*
    @param {Function} callback
  ###
  simpleLogin: (callback) ->
    goog.asserts.assert !@authClient, 'Can be called only once'
    @authClient = new window.FirebaseSimpleLogin @root, callback

  loginViaFacebook: ->
    @authClient.login 'facebook',
      rememberMe: true
      # TODO(steida): user_likes
      scope: 'email'

  logout: ->
    @authClient.logout()