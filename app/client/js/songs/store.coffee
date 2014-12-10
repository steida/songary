goog.provide 'app.songs.Store'

goog.require 'app.songs.Song'
goog.require 'este.Store'

class app.songs.Store extends este.Store

  ###*
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {este.Dispatcher} dispatcher
    @constructor
    @extends {este.Store}
  ###
  constructor: (@routes, @storage, @dispatcher) ->
    super()
    @name = 'songs'

    ###*
      @type {Array<app.songs.Song>}
    ###
    @recentlyUpdatedSongs = []

    ###*
      @type {Array<app.songs.Song>}
    ###
    @songsByUrl = []

    ###*
      @type {Array<app.songs.Song>}
    ###
    @foundSongs = []

    @dispatcherId = @dispatcher.register (action, payload) =>
      switch action
        when app.Actions.LOAD_ROUTE then @loadRoute_ payload
        when app.Actions.SEARCH_SONG then @searchSong_ payload.query

  ###*
    @param {Object} payload
    @return {goog.Promise}
    @private
  ###
  loadRoute_: (payload) ->
    {route, params} = payload
    switch route
      when @routes.song
        @storage.getSong params
          .then (songs) =>
            if !songs.length
              throw goog.net.HttpStatus.NOT_FOUND
            @fromJson songsByUrl: songs
      when @routes.recentlyUpdatedSongs
        @storage.getRecentlyUpdatedSongs()
          .then (songs) =>
            @fromJson recentlyUpdatedSongs: songs
      else
        null

  ###*
    @param {string} query
    @return {!goog.Promise}
    @private
  ###
  searchSong_: (query) ->
    @storage.searchSongByQuery(query).then (songs) =>
      @fromJson foundSongs: songs

  ###*
    @override
  ###
  fromJson: (json) ->
    toSong = (json) => new app.songs.Song json
    if json.foundSongs
      @foundSongs = json.foundSongs.map toSong
    if json.recentlyUpdatedSongs
      @recentlyUpdatedSongs = json.recentlyUpdatedSongs.map toSong
    if json.songsByUrl
      @songsByUrl = json.songsByUrl.map toSong
    @notify()

  # ###*
  #   @param {app.songs.Song} song
  #   @return {goog.Promise}
  # ###
  # publish: (song) ->
  #   # publishedSong = @createPublishedSong_ song
  #   # errors = publishedSong.validatePublished()
  #   # if errors.length
  #   #   return goog.Promise.reject errors
  #   #
  #   # @dispatcher.dispatch Store.Actions.PUBLISH_SONG,
  #   #   song: song
  #   #   json: publishedSong.toJson()

  # ###*
  #   @param {app.songs.Song} song
  #   @return {app.songs.Song}
  #   @private
  # ###
  # createPublishedSong_: (song) ->
  #   # json = song.toJson()
  #   # json.publisher = @usersStore.user.uid
  #   # delete json.inTrash
  #   # @instanceFromJson app.songs.Song, json

  # ###*
  #   @param {app.songs.Song} song
  #   @return {goog.Promise}
  # ###
  # unpublish: (song) ->
  #   # @dispatcher.dispatch Store.Actions.UNPUBLISH_SONG,
  #   #   song: song
  #     when actions.PUBLISH_SONG
  #       @xhr
  #         .put @routes.api.songs.id.url(id: payload.song.id), payload.json
  #         .then => @usersStore.setSongPublisher payload.song
  #     when actions.UNPUBLISH_SONG
  #       @xhr
  #         .delete @routes.api.songs.id.url(id: payload.song.id)
  #         .then => @usersStore.removeSongPublisher payload.song
