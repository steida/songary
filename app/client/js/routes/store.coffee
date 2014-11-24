goog.provide 'app.routes.Store'

goog.require 'este.Store'
goog.require 'goog.net.HttpStatus'

class app.routes.Store extends este.Store

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {app.Storage} storage
    @param {app.songs.Store} songsStore
    @param {app.users.Store} usersStore
    @param {este.Dispatcher} dispatcher
    @param {este.Router} router
    @constructor
    @extends {este.Store}
  ###
  constructor: (@actions, @routes, @storage, @songsStore, @usersStore,
      @dispatcher, @router) ->

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

    switch route
      when @routes.me
        if !@usersStore.isLogged()
          throw goog.net.HttpStatus.NOT_FOUND
      when @routes.mySong, @routes.editSong
        if !@usersStore.songById params.id
          throw goog.net.HttpStatus.NOT_FOUND
      when @routes.song
        return @storage.getSong(params).then (songs) =>
          if !songs.length
            throw goog.net.HttpStatus.NOT_FOUND
          @songsStore.fromJson songsByUrl: songs
      when @routes.recentlyUpdatedSongs
        return @storage.getRecentlyUpdatedSongs().then (songs) =>
          @songsStore.fromJson recentlyUpdatedSongs: songs

    goog.net.HttpStatus.OK
