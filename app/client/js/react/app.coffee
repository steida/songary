goog.provide 'app.react.App'

goog.require 'goog.net.HttpStatus'

class app.react.App

  ###*
    @param {app.Store} appStore
    @param {app.Routes} routes
    @param {app.react.Layout} layout
    @param {app.react.pages.Home} home
    @param {app.react.pages.EditSong} editSong
    @param {app.react.pages.Song} song
    @param {app.react.pages.NotFound} notFound
    @constructor
  ###
  constructor: (appStore, routes, layout,
      home, editSong, song, notFound) ->

    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'app',
          layout.create page: @page()

      page: ->
        # PATTERN(steida): Here we can handle various edge states.
        switch appStore.httpStatus
          when goog.net.HttpStatus.NOT_FOUND then return notFound

        switch routes.active
          when routes.home then home
          when routes.myNewSong, routes.editMySong then editSong
          when routes.mySong then song
          when routes.notFound then notFound