goog.provide 'app.react.App'

goog.require 'goog.dom'
goog.require 'goog.events'
goog.require 'goog.net.HttpStatus'

class app.react.App

  ###*
    @param {app.user.Store} userStore
    @param {app.Routes} routes
    @param {app.react.Layout} layout
    @param {app.react.pages.Home} homePage
    @param {app.react.pages.EditSong} editSongPage
    @param {app.react.pages.Song} songPage
    @param {app.react.pages.NotFound} notFoundPage
    @constructor
  ###
  constructor: (userStore, routes, layout,
      homePage, editSongPage, songPage, notFoundPage) ->

    {div} = React.DOM

    @component = React.createClass

      render: ->
        div className: 'app',
          layout.component page: @getActiveRoutePage()

      getActiveRoutePage: ->
        switch routes.active
          when routes.home then homePage
          when routes.myNewSong, routes.editMySong then editSongPage
          when routes.mySong then songPage
          when routes.notFound then notFoundPage

      componentDidMount: ->
        goog.events.listen window, 'orientationchange', @onOrientationChange

      onOrientationChange: (e) ->
        @scrollWindowTop()

      scrollWindowTop: ->
        goog.dom.getDocumentScrollElement().scrollTop = 0
