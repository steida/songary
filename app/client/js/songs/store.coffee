goog.provide 'app.songs.Store'

goog.require 'app.songs.Song'
goog.require 'este.labs.Store'
goog.require 'goog.object'

class app.songs.Store extends este.labs.Store

  ###*
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: (@localHistory) ->
    super 'songs'

  ###*
    From Firebase songs byUrl. Plural, because more songs can share the same
    name and artist.
    @type {Object}
  ###
  songsByUrl: null

  ###*
    TODO: Show all song versions, not just first. /beatles/let-it-be should show
    all songs published with this url. /beatles/let-it-be/yz525kwxli9s will be
    unique url.
    @return {app.songs.Song}
  ###
  songByUrl: ->
    json = goog.object.getAnyValue @songsByUrl
    @instanceFromJson app.songs.Song, json || {}

  ###*
    @override
  ###
  fromJson: (json) ->
    @lastTenSongs = @asArray json.lastTenSongs || {}
      .map @instanceFromJson app.songs.Song
