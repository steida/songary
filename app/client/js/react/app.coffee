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
        page = @page()

        div className: 'app',
          layout.component
            component: @component page
            isSongPage: page == songPage

      page: ->
        switch routes.active
          when routes.home then homePage
          when routes.myNewSong, routes.editMySong then editSongPage
          when routes.mySong then songPage
          else notFoundPage

      component: (page) ->
        switch page
          when songPage then @songPageComponent()
          when editSongPage then @editSongPageComponent()
          else page.component()

      songPageComponent: ->
        song = userStore.songByRoute routes.active
        return notFoundPage.component() if !song
        songPage.component song: song

      editSongPageComponent: ->
        editMode = routes.active == routes.editMySong
        if editMode
          song = userStore.songByRoute routes.active
          return notFoundPage.component() if !song
        else
          song = userStore.newSong
        editSongPage.component editMode: editMode, song: song

      componentDidMount: ->
        goog.events.listen window, 'orientationchange', @onOrientationChange

      onOrientationChange: (e) ->
        @scrollWindowTop()

      scrollWindowTop: ->
        goog.dom.getDocumentScrollElement().scrollTop = 0
