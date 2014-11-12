goog.provide 'app.routes.Store'

goog.require 'este.Store'
goog.require 'goog.net.HttpStatus'

class app.routes.Store extends este.Store

  ###*
    @param {app.Actions} actions
    @param {app.Dispatcher} dispatcher
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {este.Router} router
    @param {app.songs.Store} songsStore
    @param {app.users.Store} usersStore
    @constructor
    @extends {este.Store}
  ###
  constructor: (@actions, @dispatcher, @routes, @storage, @router,
      @songsStore, @usersStore) ->

    @dispatcher.register (action, payload) =>
      switch action
        when app.Actions.LOAD_ROUTE then @loadRoute_ payload

  start: ->
    @routes.addToEste @router, @onRouteMatch_.bind @
    @router.start()

  onRouteMatch_: (route, params) ->
    @actions.loadRoute route, params
      .then => @routes.setActive route, params
      .thenCatch (reason) => @routes.trySetErrorRoute reason
      .then => @actions.renderApp()

  ###*
    @param {Object} payload
    @return {goog.Promise|number}
    @private
  ###
  loadRoute_: (payload) ->
    {route, params} = payload
    HttpStatus = goog.net.HttpStatus

    switch route
      when @routes.about, @routes.home, @routes.newSong, @routes.songs, @routes.trash
        HttpStatus.OK
      when @routes.me
        if !@usersStore.isLogged() then throw HttpStatus.NOT_FOUND
        HttpStatus.OK
      when @routes.mySong, @routes.editSong
        if !@usersStore.songById params.id then throw HttpStatus.NOT_FOUND
        HttpStatus.OK
      when @routes.song
        @storage.getSong(params).then (songs) =>
          if !songs.length then throw HttpStatus.NOT_FOUND
          @songsStore.fromJson songsByUrl: songs
      when @routes.recentlyUpdatedSongs
        @storage.getRecentlyUpdatedSongs().then (songs) =>
          @songsStore.fromJson recentlyUpdatedSongs: songs
      else
        throw HttpStatus.NOT_FOUND
