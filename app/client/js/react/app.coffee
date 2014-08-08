goog.provide 'app.react.App'

goog.require 'goog.dom'
goog.require 'goog.events'
goog.require 'goog.net.HttpStatus'

class app.react.App

  ###*
    @param {app.Store} appStore
    @param {app.user.Store} userStore
    @param {app.Routes} routes
    @param {app.react.Layout} layout
    @param {app.react.pages.Home} homePage
    @param {app.react.pages.EditSong} editSongPage
    @param {app.react.pages.Song} songPage
    @param {app.react.pages.NotFound} notFoundPage
    @constructor
  ###
  constructor: (appStore, userStore, routes, layout,
      homePage, editSongPage, songPage, notFoundPage) ->

    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'app',
          layout.create page: @getActiveRoutePage()

      getActiveRoutePage: ->
        # PATTERN(steida): Here we can handle various edge states.
        switch appStore.httpStatus
          when goog.net.HttpStatus.NOT_FOUND then return notFoundPage

        switch routes.active
          when routes.home then homePage
          when routes.myNewSong then editSongPage
          when routes.mySong, routes.editMySong
            # NOTE(steida): Song can be deleted anytime. 
            return notFoundPage if not userStore.songByRoute routes.active
            if routes.active == routes.mySong then songPage else editSongPage
          when routes.notFound then notFoundPage
          else notFoundPage

      componentDidMount: ->
        goog.events.listen window, 'orientationchange', @onOrientationChange

      onOrientationChange: (e) ->
        @scrollWindowTop()

      scrollWindowTop: ->
        goog.dom.getDocumentScrollElement().scrollTop = 0