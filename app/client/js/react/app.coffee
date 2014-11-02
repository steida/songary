goog.provide 'app.react.App'

goog.require 'goog.dom'
goog.require 'goog.events'

class app.react.App

  ###*
    @param {app.Routes} routes
    @param {app.Title} appTitle
    @param {app.users.Store} usersStore
    @param {app.songs.Store} songsStore
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.react.pages.About} aboutPage
    @param {app.react.pages.EditSong} editSongPage
    @param {app.react.pages.Me} mePage
    @param {app.react.pages.MySongs} mySongs
    @param {app.react.pages.NotFound} notFoundPage
    @param {app.react.pages.RecentlyUpdatedSongs} recentlyUpdatedSongsPage
    @param {app.react.pages.Songs} songsPage
    @param {app.react.pages.Song} songPage
    @param {app.react.pages.Trash} trashPage
    @constructor
  ###
  constructor: (routes, appTitle,
      usersStore, songsStore,
      header, footer,
      aboutPage, editSongPage, mePage, mySongs, notFoundPage,
      recentlyUpdatedSongsPage, songsPage, songPage, trashPage) ->

    {div} = React.DOM

    @component = React.createFactory React.createClass

      render: ->
        pageProps = {}
        page = @getActivePage pageProps

        div className: 'app active-page-' + @getPageClassName(page),
          header.component()
          page.component pageProps
          footer.component()
          # Fix for "The "fb-root" div has not been created, auto-creating"
          div id: 'fb-root'

      getActivePage: (props) ->
        page = switch routes.active
          when routes.home then mySongs
          when routes.newSong then editSongPage
          when routes.songs then songsPage
          when routes.recentlyUpdatedSongs then recentlyUpdatedSongsPage
          when routes.song then @getPublishedSongPage props
          when routes.mySong, routes.editSong then @getLocalSongPage props
          when routes.trash then trashPage
          when routes.about then aboutPage
          when routes.me then usersStore.isLogged() && mePage
        # 404 is handled in two places for a good reason.
        # app.Storage can return 404, which is used by router, but app data can
        # be changed anytime later, so that's why render has to check it again.
        page || notFoundPage

      getPublishedSongPage: (props) ->
        # TODO: Show all song versions, not just first.
        # /beatles/let-it-be -> All songs published under this url.
        # /beatles/let-it-be/yz525kwxli9s -> One song.
        props.song = songsStore.songsByUrl[0]
        songPage

      getLocalSongPage: (props) ->
        song = usersStore.songByRoute routes.active
        # Local song can be removed anytime, for example from different tab.
        return if !song
        props.song = song
        if routes.active == routes.mySong then songPage else editSongPage

      getPageClassName: (page) ->
        switch page
          when aboutPage then 'about'
          when editSongPage then 'edit-song'
          when mePage then 'me'
          when mySongs then 'home'
          when notFoundPage then 'notfound'
          when songPage then 'song'
          when songsPage, recentlyUpdatedSongsPage then 'songs'
          when trashPage then 'trash'

      componentDidMount: ->
        goog.events.listen window, 'orientationchange', @onOrientationChange
        songsStore.listen 'change', @updateUI
        usersStore.listen 'change', @updateUI

      onOrientationChange: ->
        goog.dom.getDocumentScrollElement().scrollTop = 0

      updateUI: ->
        @forceUpdate()

      componentDidUpdate: ->
        document.title = appTitle.get()
