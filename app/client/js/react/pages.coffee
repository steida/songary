goog.provide 'app.react.Pages'

class app.react.Pages

  ###*
    @param {app.Routes} routes
    @param {este.react.Element} element
    @param {app.react.layout.Header} header
    @param {app.react.layout.Footer} footer
    @param {app.songs.Store} songsStore
    @param {app.users.Store} usersStore
    @param {app.about.react.Page} aboutPage
    @param {app.home.react.Page} homePage
    @param {app.me.react.Page} mePage
    @param {app.notFound.react.Page} notFoundPage
    @param {app.songs.react.EditSongPage} editSongPage
    @param {app.songs.react.RecentlyUpdatedSongsPage} recentlyUpdatedSongsPage
    @param {app.songs.react.SongsPage} songsPage
    @param {app.songs.react.Song} songPage
    @param {app.songs.react.TrashPage} trashPage
    @constructor
  ###
  constructor: (routes, element, header, footer,
      songsStore, usersStore,
      aboutPage, homePage, mePage, notFoundPage, editSongPage,
      recentlyUpdatedSongsPage, songsPage, songPage, trashPage) ->
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
