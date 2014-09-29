goog.provide 'app.songs.Store'

goog.require 'app.songs.Song'
goog.require 'este.labs.Store'

class app.songs.Store extends este.labs.Store

  ###*
    @param {app.Dispatcher} dispatcher
    @param {app.Routes} routes
    @param {app.Xhr} xhr
    @param {app.user.Store} userStore
    @constructor
    @extends {este.labs.Store}
  ###
  constructor: (@dispatcher, @routes, @xhr, @userStore) ->
    super 'songs'

    ###*
      @type {Array.<app.songs.Song>}
    ###
    @recentlyUpdatedSongs = []

    ###*
      @type {Array.<app.songs.Song>}
    ###
    @songsByUrl = []

    ###*
      @type {Array.<app.songs.Song>}
    ###
    @foundSongs = []

    @dispatcherIndex = @dispatcher.register @handleAction_.bind @

  @Actions:
    PUBLISH_SONG: 'publishsong'
    SEARCH: 'searchsongs'
    UNPUBLISH_SONG: 'unpublishsong'

  handleAction_: (action, payload) ->
    switch action
      when Store.Actions.PUBLISH_SONG
        @xhr
          .put @routes.api.songs.id.url(id: payload.song.id), payload.json
          .then => @userStore.setSongPublisher payload.song
      when Store.Actions.SEARCH
        @xhr
          .get @routes.api.songs.search.url null, query: payload.query
          .then (songs) =>
            @fromJson foundSongs: songs
            @notify()
      when Store.Actions.UNPUBLISH_SONG
        @xhr
          .delete @routes.api.songs.id.url(id: payload.song.id)
          .then => @userStore.removeSongPublisher payload.song

  ###*
    @override
  ###
  fromJson: (json) ->
    if json.foundSongs
      @foundSongs = json.foundSongs.map @instanceFromJson app.songs.Song
    if json.recentlyUpdatedSongs
      @recentlyUpdatedSongs = json.recentlyUpdatedSongs.map @instanceFromJson app.songs.Song
    if json.songsByUrl
      @songsByUrl = json.songsByUrl.map @instanceFromJson app.songs.Song

  ###*
    @param {app.songs.Song} song
    @return {goog.Promise}
  ###
  publish: (song) ->
    publishedSong = @createPublishedSong_ song
    errors = publishedSong.validatePublished()
    if errors.length
      return goog.Promise.reject errors

    @dispatcher.dispatch Store.Actions.PUBLISH_SONG,
      song: song
      json: publishedSong.toJson()

  ###*
    @param {app.songs.Song} song
    @return {app.songs.Song}
    @private
  ###
  createPublishedSong_: (song) ->
    json = song.toJson()
    json.publisher = @userStore.user.uid
    delete json.inTrash
    @instanceFromJson app.songs.Song, json

  ###*
    @param {app.songs.Song} song
    @return {goog.Promise}
  ###
  unpublish: (song) ->
    @dispatcher.dispatch Store.Actions.UNPUBLISH_SONG,
      song: song

  ###*
    @param {string} query
    @return {goog.Promise}
  ###
  search: (query) ->
    @dispatcher.dispatch Store.Actions.SEARCH,
      query: query
