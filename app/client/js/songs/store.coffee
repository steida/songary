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
    @lastTenSongs = []
    @songsByUrl = []

  ###*
    @type {Array.<app.songs.Song>}
  ###
  lastTenSongs: null

  ###*
    @type {Array.<app.songs.Song>}
  ###
  songsByUrl: null

  ###*
    @override
  ###
  fromJson: (json) ->
    if json.lastTenSongs
      @lastTenSongs = @asArray json.lastTenSongs || {}
        .map @instanceFromJson app.songs.Song
    if json.songsByUrl
      @songsByUrl = @asArray json.songsByUrl || {}
        .map @instanceFromJson app.songs.Song
