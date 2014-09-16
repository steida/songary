goog.provide 'app.songs.Store'

goog.require 'app.songs.Song'
goog.require 'este.labs.Store'
goog.require 'goog.object'

class app.songs.Store extends este.labs.Store

  ###*
    @param {app.LocalHistory} localHistory
    @param {app.RestStorage} restStorage
    @param {app.Routes} routes
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: (@localHistory, @restStorage, @routes) ->
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

  ###*
    @param {app.songs.Song} song
    @param {Object} user
    @return {!goog.Promise}
  ###
  publish: (song, user) ->
    json = song.toPublishedJson user.id
    song = @instanceFromJson app.songs.Song, json
    errors = song.validatePublished()
    if errors.length
      return goog.Promise.reject errors
    @restStorage
      .put @routes.api.song.url(id: json.id), json
      .then (value) ->
        # TODO: Update store, then notify, co delal firebase?
        # @userStore.addPublishedSong json.id, url
        # ? nebo songs store? hmm, nevim, asi jak sem to dělal :-)
