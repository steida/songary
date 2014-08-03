goog.provide 'app.Firebase'

class app.Firebase

  ###*
    @constructor
  ###
  constructor: ->
    # TODO(steida): Use server data, make it isomorphic.
    if window.Firebase
      @root = new window.Firebase 'https://shining-fire-6810.firebaseio.com/'
      @authenticated = @root.child '.info/authenticated'

  ###*
    @param {Function} callback
  ###
  initSimpleLogin: (callback) ->
    if window.FirebaseSimpleLogin
      @authClient = new window.FirebaseSimpleLogin @root, callback

# userRef = new Firebase 'https://shining-fire-6810.firebaseio.com/users/1/newSong'
# userRef.on 'value', (snapshot) =>
#   json = snapshot.val()
#   return if !json
#   newSong = @songsStore.instanceFromJson app.songs.Song, json
#   @songsStore.newSong = newSong
#   @notify()
# @myFirebaseRef = new Firebase 'https://shining-fire-6810.firebaseio.com/'
# @myFirebaseRef
#   .child 'songs'
#   .on 'value', (snapshot) =>
#     @setState 'songs': snapshot.val()

# @songsStore.listen 'change', (e) =>
#   @notify()

# firebase.authenticated.on 'value', (snap) =>
#   console.log 'firebase.authenticated.on'
#   setTimeout =>
#     @notify()
#   , 10