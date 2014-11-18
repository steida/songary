goog.provide 'app.react.Pages'

class app.react.Pages

  ###*
    @param {app.Routes} routes
    @param {app.react.Footer} footer
    @param {app.react.Header} header
    @param {este.react.Element} element
    @param {app.songs.Store} songsStore
    @param {app.users.Store} usersStore
    @param {app.react.pages.About} aboutPage
    @param {app.react.pages.EditSong} editSongPage
    @param {app.react.pages.Home} homePage
    @param {app.react.pages.Me} mePage
    @param {app.react.pages.NotFound} notFoundPage
    @param {app.react.pages.RecentlyUpdatedSongs} recentlyUpdatedSongsPage
    @param {app.react.pages.Songs} songsPage
    @param {app.react.pages.Song} songPage
    @param {app.react.pages.Trash} trashPage
    @constructor
  ###
  constructor: (routes, footer, header, element,
      songsStore, usersStore, aboutPage, editSongPage, homePage, mePage,
      notFoundPage, recentlyUpdatedSongsPage, songsPage, songPage, trashPage) ->
    {div} = element

    @component = React.createFactory React.createClass

      render: ->
        pageProps = {}
        page = @getPage pageProps
        pageClassName = @getPageClassName page

        div className: "pages #{pageClassName}",
          header.component()
          page.component pageProps
          footer.component()

      getPage: (props) ->
        page = switch routes.active
          when routes.about then aboutPage
          when routes.home then homePage
          when routes.me then usersStore.isLogged() && mePage
          when routes.mySong, routes.editSong then @getLocalSongPage props
          when routes.newSong then editSongPage
          when routes.recentlyUpdatedSongs then recentlyUpdatedSongsPage
          when routes.song then @getPublishedSongPage props
          when routes.songs then songsPage
          when routes.trash then trashPage
        page || notFoundPage

      getLocalSongPage: (props) ->
        song = usersStore.songByRoute routes.active
        # Local song can be removed anytime, for example from different tab.
        return if !song
        props.song = song
        if routes.active == routes.mySong then songPage else editSongPage

      getPublishedSongPage: (props) ->
        # TODO: Show all song versions, not just first.
        # /beatles/let-it-be -> All songs published under this url.
        # /beatles/let-it-be/yz525kwxli9s -> One song.
        props.song = songsStore.songsByUrl[0]
        songPage

      getPageClassName: (page) ->
        switch page
          when aboutPage then 'about'
          when editSongPage then 'edit-song'
          when mePage then 'me'
          when homePage then 'home'
          when notFoundPage then 'notfound'
          when songPage then 'song'
          when songsPage, recentlyUpdatedSongsPage then 'songs'
          when trashPage then 'trash'
