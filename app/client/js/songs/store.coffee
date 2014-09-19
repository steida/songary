goog.provide 'app.songs.Store'

goog.require 'app.songs.Song'
goog.require 'este.labs.Store'
goog.require 'goog.object'

class app.songs.Store extends este.labs.Store

  ###*
    @param {app.LocalHistory} localHistory
    @param {app.Routes} routes
    @param {app.Xhr} xhr
    @param {app.user.Store} userStore
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: (@localHistory, @routes, @xhr, @userStore) ->
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
    # if json.lastTenSongs
    #   @lastTenSongs = @asArray json.lastTenSongs || {}
    #     .map @instanceFromJson app.songs.Song
    if json.songsByUrl
      @songsByUrl = @asArray json.songsByUrl || {}
        .map @instanceFromJson app.songs.Song

  ###*
    @param {app.songs.Song} song
    @return {!goog.Promise}
  ###
  publish: (song) ->
    json = song.toJson()
    json.publisher = @userStore.user.uid
    published = @instanceFromJson app.songs.Song, json

    errors = published.validatePublished()
    if errors.length
      return goog.Promise.reject errors

    @xhr
      .put @routes.api.song.url(id: song.id), published.toJson()
      .then (value) =>
        @userStore.setSongPublisher song

  ###*
    @param {app.songs.Song} song
    @return {!goog.Promise}
  ###
  unpublish: (song) ->
    @xhr
      .delete @routes.api.song.url(id: song.id)
      .then (value) =>
        @userStore.removeSongPublisher song
