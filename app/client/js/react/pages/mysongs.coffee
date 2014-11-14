goog.provide 'app.react.pages.MySongs'

class app.react.pages.MySongs

  ###*
    @param {app.Routes} routes
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, usersStore, element) ->
    {div, ul, li, p, nav, a} = element

    @component = React.createFactory React.createClass

      render: ->
        # TODO: Add byName sort option.
        songs = usersStore.songsSortedByUpdatedAt()
        visibleSongs = songs.filter (song) -> !song.inTrash
        deletedSongs = songs.filter (song) -> song.inTrash

        div className: 'page',
          if songs.length
            ul className: 'songs', visibleSongs.map (song) ->
              li key: song.id,
                a
                  href: routes.mySong.url song
                  touchAction: 'pan-y'
                , "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          else
            div {},
              p {}, MySongs.MSG_NO_SONGS
              p {},
                a
                  href: routes.newSong.url()
                  touchAction: 'none'
                , MySongs.MSG_ADD
                MySongs.MSG_OR
                a
                  href: routes.songs.url()
                  touchAction: 'none'
                , MySongs.MSG_SEARCH
                MySongs.MSG_ONE
          nav {},
            if songs.length > 0
              a
                className: 'btn btn-link'
                href: routes.newSong.url()
                touchAction: 'none'
              , MySongs.MSG_ADD_NEW_SONG
            if deletedSongs.length > 0
              a
                className: 'btn btn-link'
                href: routes.trash.url()
                touchAction: 'none'
              , "Trash (#{deletedSongs.length})"

  @MSG_ADD: goog.getMsg 'Add'
  @MSG_ADD_NEW_SONG: goog.getMsg 'Add Song'
  @MSG_NO_SONGS: goog.getMsg "You have no song stored on your device yet."
  @MSG_ONE: goog.getMsg ' one.'
  @MSG_OR: goog.getMsg ' or '
  @MSG_SEARCH: goog.getMsg 'search'
