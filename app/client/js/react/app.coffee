goog.provide 'app.react.App'

goog.require 'goog.dom'
goog.require 'goog.events'

class app.react.App

  ###*
    @param {app.user.Store} userStore
    @param {app.Routes} routes
    @param {app.Title} appTitle
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.react.pages.Home} homePage
    @param {app.react.pages.EditSong} editSongPage
    @param {app.react.pages.Song} songPage
    @param {app.react.pages.NotFound} notFoundPage
    @constructor
  ###
  constructor: (userStore, routes, appTitle,
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

      pageProps: ->
        switch routes.active
          when routes.mySong, routes.editMySong
            song = userStore.songByRoute routes.active
            song && song: song
          else {}

      page: ->
        switch routes.active
          when routes.home then homePage
          when routes.myNewSong, routes.editMySong then editSongPage
          when routes.mySong then songPage

      componentDidMount: ->
        goog.events.listen window, 'orientationchange', @onOrientationChange
        userStore.listen 'change', @onStoreChange

      onOrientationChange: ->
        goog.dom.getDocumentScrollElement().scrollTop = 0

      onStoreChange: ->
        @forceUpdate()

      componentDidUpdate: ->
        document.title = appTitle.get()
