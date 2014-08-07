###
  App specific externs.

  PATTERN(steida): There are several ways to prevent the compiler from
  renaming symbols: http://stackoverflow.com/questions/11681070/exposing-dynamically-created-functions-on-objects-with-closure-compiler
  Expose annotation seems to be ideal, but unfortunatelly it's brittle: http://goo.gl/rOQP2c
  Quoting properties is verbose and tricky.
  Externs ftw.
###
class appUserStore
  appUserStore::songs
  appUserStore::newSong
  # User.
  appUserStore::user
  # User props and nested props.
  appUserStore::displayName
  appUserStore::id
  appUserStore::provider
  appUserStore::thirdPartyUserData
  appUserStore::uid

# PATTERN(steida): For app.songs.Song create appSongsSong.
class appSongsSong
  appSongsSong::id
  appSongsSong::created
  appSongsSong::updated
  appSongsSong::name
  appSongsSong::urlName
  appSongsSong::artist
  appSongsSong::urlArtist
  appSongsSong::creator
  appSongsSong::lyrics

# TODO(steida): Move to separate externs repo. Use typedef.

class Firebase

  ###*
    @param {string} firebaseURL
    @constructor
  ###
  constructor: (firebaseURL) ->

  ###*
    @param {string} authToken
    @param {Function=} onComplete
    @param {Function=} onCancel
  ###
  auth: (authToken, onComplete, onCancel) ->

  unauth: ->

  ###*
    @param {string} childPath
    @return {Firebase}
  ###
  child: (childPath) ->

  ###*
    @return {Firebase}
  ###
  parent: ->

  ###*
    @return {string}
  ###
  name: ->

  ###*
    @param {(Object|string|number|boolean)} value
    @param {Function=} onComplete
  ###
  set: (value, onComplete) ->

  ###*
    @param {Object} value
    @param {Function=} onComplete
  ###
  update: (value, onComplete) ->

  ###*
    @param {Function=} onComplete
  ###
  remove: (onComplete) ->

  ###*
    @param {(Object|string|number|boolean)=} value
    @param {Function=} onComplete
    @return {Firebase}
  ###
  push: (value, onComplete) ->

  ###*
    @param {(Object|string|number|boolean)} value
    @param {(string|number)} priority
    @param {Function=} onComplete
  ###
  setWithPriority: (value, priority, onComplete) ->

  ###*
    @param {(string|number)} priority
    @param {Function=} onComplete
  ###
  setPriority: (priority, onComplete) ->

  ###*
    @param {Function} updateFunction
    @param {Function=} onComplete
    @param {Function=} applyLocally
  ###
  transaction: (updateFunction, onComplete, applyLocally) ->

  goOffline: ->

  goOnline: ->

  # TODO(steida): This should be Firebase Query interface or base class.
  # Now everything is externed on Firebase class. Use more accurate annotations.

  ###*
    @param {string} eventType
    @param {function(FirebaseDataSnapshot)} callback
    @param {Function=} cancelCallback
    @param {Object=} context
    @return {Function}
  ###
  on: (eventType, callback, cancelCallback, context) ->

  ###*
    @param {string=} eventType
    @param {Function=} callback
    @param {Object=} context
    @return {Function}
  ###
  off: (eventType, callback, context) ->

  ###*
    @param {string} eventType
    @param {function(FirebaseDataSnapshot)} successCallback
    @param {Function=} failureCallback
    @param {Object=} context
    @return {Function}
  ###
  once: (eventType, successCallback, failureCallback, context) ->

  ###*
    @param {number} limit
    @return {Firebase} Actually it returns Query
  ###
  limit: (limit) ->

  ###*
    @param {(string|number)=} priority
    @param {(string|number)=} name
    @return {Firebase} Actually it returns Query
  ###
  startAt: (priority, name) ->

  ###*
    Get a Firebase reference to the Query's location.
    @return {Firebase}
  ###
  ref: ->

class FirebaseSimpleLogin

  ###*
    @param {Firebase} ref
    @param {Function} callback
    @param {Object=} context
    @constructor
  ###
  constructor: (ref, callback, context) ->

  ###*
    @param {string} provider
    @param {Object=} options
  ###
  login: (provider, options) ->

  logout: ->

  ###*
    @param {string} email
    @param {string} password
    @param {Function=} callback
  ###
  createUser: (email, password, callback) ->

  ###*
    @param {string} email
    @param {string} oldPassword
    @param {string} newPassword
    @param {Function} callback
  ###
  changePassword: (email, oldPassword, newPassword, callback) ->

  ###*
    @param {string} email
    @param {Function} callback
  ###
  sendPasswordResetEmail: (email, callback) ->

  ###*
    @param {string} email
    @param {string} password
    @param {Function} callback
  ###
  removeUser: (email, password, callback) ->

class FirebaseDataSnapshot

  ###*
    @constructor
  ###
  constructor: ->

  ###*
    @return {(Object|String|Number|Boolean|Null)}
  ###
  val: ->

  ###*
    @param {string} childPath
    @return {FirebaseDataSnapshot}
  ###
  child: (childPath) ->

  ###*
    @param {function(FirebaseDataSnapshot): boolean} childAction
    @return {boolean}
  ###
  forEach: (childAction) ->

  ###*
    @param {string} childPath
    @return {boolean}
  ###
  hasChild: (childPath) ->

  ###*
    @return {boolean}
  ###
  hasChildren: ->

  ###*
    @return {string}
  ###
  name: ->

  ###*
    @return {number}
  ###
  numChildren: ->

  ###*
    @return {Firebase}
  ###
  ref: ->

  ###*
    @return {(string|number|null)}
  ###
  getPriority: ->

  ###*
    @return {Object}
  ###
  exportVal: ->