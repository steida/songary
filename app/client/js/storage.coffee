goog.provide 'app.Storage'

goog.require 'este.Storage'

class app.Storage extends este.Storage

  ###*
    @param {app.Dispatcher} dispatcher
    @param {app.LocalStorage} localStorage
    @param {app.Routes} routes
    @param {app.Xhr} xhr
    @param {app.songs.Store} songsStore
    @param {app.users.Store} usersStore
    @constructor
    @extends {este.Storage}
  ###
  constructor: (dispatcher, @localStorage, @routes, @xhr,
      @songsStore, @usersStore) ->

    dispatcher.register (action, payload) =>
      switch action
        when app.Actions.LOAD_ROUTE
          @loadRoute_ payload.route, payload.params
        when app.Actions.SEARCH_SONG
          @searchSong_ payload.query

  init: ->
    @localStorage.sync [@usersStore]

  ###*
    @param {este.Route} route
    @param {Object} params
    @return {!goog.Promise}
    @private
  ###
  loadRoute_: (route, params) ->
    switch route
      when @routes.about, @routes.home, @routes.newSong, @routes.trash
        @ok()
      when @routes.me
        return @notFound() if !@usersStore.isLogged()
        @ok()
      when @routes.mySong, @routes.editSong
        return @notFound() if !@usersStore.songById params.id
        @ok()
      when @routes.song
        @xhr
          .get @routes.api.songs.byUrl.url params
          .then (songs) =>
            return @notFound() if !songs.length
            @songsStore.fromJson songsByUrl: songs
      when @routes.songs
        @ok()
      when @routes.recentlyUpdatedSongs
        @xhr
          .get @routes.api.songs.recentlyUpdated.url()
          .then (songs) =>
            @songsStore.fromJson recentlyUpdatedSongs: songs
      else
        @notFound()

  ###*
    @param {string} query
    @return {!goog.Promise}
    @private
  ###
  searchSong_: (query) ->
    @xhr
      .get @routes.api.songs.search.url null, query: query
      .then (songs) =>
        @songsStore.fromJson foundSongs: songs

#     when actions.PUBLISH_SONG
#       @xhr
#         .put @routes.api.songs.id.url(id: payload.song.id), payload.json
#         .then => @usersStore.setSongPublisher payload.song
#     when actions.UNPUBLISH_SONG
#       @xhr
#         .delete @routes.api.songs.id.url(id: payload.song.id)
#         .then => @usersStore.removeSongPublisher payload.song
