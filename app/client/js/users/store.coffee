goog.provide 'app.user.Store'

goog.require 'app.songs.Song'
goog.require 'este.labs.Store'
goog.require 'goog.array'

class app.user.Store extends este.labs.Store

  ###*
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: ->
    super 'user'
    @songs = []
    @newSong = new app.songs.Song

  ###*
    @type {Array.<app.songs.Song>}
  ###
  songs: null

  ###*
    @type {app.songs.Song}
  ###
  newSong: null

  ###*
    @return {Array.<app.songs.Song>}
  ###
  allSongs: ->
    goog.array.sortObjectsByKey @songs, 'name'
    @songs

  ###*
    @return {Array.<app.ValidationError>}
  ###
  addNewSong: ->
    errors = @newSong.validate()
    if @contains @newSong
      errors.push new app.ValidationError 'name',
        'Song with such name and artist already exists.'
    return errors if errors.length
    @songs.push @newSong
    @newSong = new app.songs.Song
    @notify()
    []

  ###*
    @param {app.songs.Song} song
  ###
  delete: (song) ->
    goog.array.remove @songs, song
    @notify()

  ###*
    @param {este.Route} route
    @return {app.songs.Song}
  ###
  songByRoute: (route) ->
    # TODO: my songs
    goog.array.find @songs, (song) -> song.id == route.params.id

  ###*
    @param {app.songs.Song} song
    @return {boolean}
  ###
  contains: (song) ->
    goog.array.some @songs, (s) ->
      s.name == song.name &&
      s.artist == song.artist

  ###*
    @param {app.songs.Song} song
    @param {string} prop
    @param {string} value
  ###
  updateSong: (song, prop, value) ->
    song[prop] = value
    song.update()
    @notify()
    # appModel.update -> @newSong = song

    # console.log 'fok'
    # pak login

    # userRef = new Firebase 'https://shining-fire-6810.firebaseio.com/users/1'
    # userRef.set
    #   newSong: JSON.parse JSON.stringify song

    #
    # myFirebaseRef.child("location/city").on("value", function(snapshot) {
    #   alert(snapshot.val());  // Alerts "San Francisco"
    # });
    #
    # console.log song

    # @firebase.user.set

    # save to firebase
    # on change, update
    # somewhere elsewhere rerender everything, hmm, storage?
    # annonymous user
    # @myFirebaseRef = new Firebase 'https://shining-fire-6810.firebaseio.com/'
    # myFirebaseRef.set({
    #   title: "Hello World!",
    # });

  ###*
    @override
  ###
  toJson: ->
    newSong: @newSong
    songs: @songs

  ###*
    @override
  ###
  fromJson: (json) ->
    @newSong = @instanceFromJson app.songs.Song, json.newSong
    @songs = json.songs.map @instanceFromJson app.songs.Song







#############################


goog.provide 'app.users.Store'

goog.require 'app.users.User'
goog.require 'goog.date.UtcDateTime'

class app.users.Store

  ###*
    @param {app.Firebase} firebase
    @constructor
  ###
  constructor: (@firebase) ->
    # Anonymous?
    # @firebase.initSimpleLogin (error, user) =>
    #   # console.log '@firebase.initSimpleLogin'
    #   if error
    #     console.log error
    #   else if user
    #     @user = user

  ###*
    @type {Object}
  ###
  user: null

  ###*
    @return {boolean}
  ###
  isLogged: -> !!@user

  logout: ->
    @firebase.authClient.logout()
    @user = null

  loginViaFacebook: ->
    @firebase.authClient.login 'facebook',
      rememberMe: true
      # TODO(steida): user_likes
      scope: 'email'

  # ###*
  #   @return {app.users.User}
  #   @private
  # ###
  # create: ->
  #   user = new app.users.User
  #   now = new goog.date.UtcDateTime().toIsoString()
  #   user.updated = user.created = now
  #   user