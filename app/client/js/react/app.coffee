goog.provide 'app.react.App'

goog.require 'goog.dom'
goog.require 'goog.events'
goog.require 'goog.net.HttpStatus'

class app.react.App

  ###*
    @param {app.user.Store} userStore
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.react.pages.Home} homePage
    @param {app.react.pages.EditSong} editSongPage
    @param {app.react.pages.Song} songPage
    @param {app.react.pages.NotFound} notFoundPage
    @constructor
  ###
  constructor: (userStore, routes,
      header, footer,
      homePage, editSongPage, songPage, notFoundPage) ->

    {div} = React.DOM

    @component = React.createClass

      render: ->
        pageProps = @pageProps()
        page = pageProps && @page() || notFoundPage

        div className: 'app',
          header.component() if page != songPage
          page.component pageProps
          footer.component() if page != songPage

      page: ->
        switch routes.active
          when routes.home then homePage
          when routes.myNewSong, routes.editMySong then editSongPage
          when routes.mySong then songPage

      pageProps: ->
        switch routes.active
          when routes.mySong, routes.editMySong
            song = userStore.songByRoute routes.active
            if song then song: song else null
          else {}

      componentDidMount: ->
        goog.events.listen window, 'orientationchange', @onOrientationChange

      onOrientationChange: (e) ->
        @scrollWindowTop()

      scrollWindowTop: ->
        goog.dom.getDocumentScrollElement().scrollTop = 0
