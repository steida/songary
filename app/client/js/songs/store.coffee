goog.provide 'app.songs.Store'

goog.require 'app.songs.Song'
goog.require 'este.labs.Store'
goog.require 'goog.array'

class app.songs.Store extends este.labs.Store

  ###*
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: ->
    super 'songs'
    @songs = []
    @newSong = new app.songs.Song

  ###*
    @type {Array.<app.songs.Song>}
  ###
  songs: null

  ###*
    New song not yet added.
    @type {app.songs.Song}
  ###
  newSong: null

  ###*
    @return {Array.<app.songs.Song>}
  ###
  all: ->
    goog.array.sortObjectsByKey @songs, 'name'
    @songs

  ###*
    PATTERN(steida): This is example why it's good to manipulate app model only
    through stores. We need to validate both song and songs, and we need to
    change not only the model. Stores ftw.
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
  mySongByRoute: (route) ->
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