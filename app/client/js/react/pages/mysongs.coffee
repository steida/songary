goog.provide 'app.react.pages.MySongs'

class app.react.pages.MySongs

  ###*
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @param {app.react.Gesture} gesture
    @constructor
  ###
  constructor: (routes, userStore, gesture) ->
    {div,ul,li,p,nav} = React.DOM
    {a} = gesture.scroll 'a'

    @component = React.createFactory React.createClass

      render: ->
        # TODO: Add byName sort option.
        songs = userStore.songsSortedByUpdatedAt()
        visibleSongs = songs.filter (song) -> !song.inTrash
        deletedSongs = songs.filter (song) -> song.inTrash

        div className: 'page',
          if songs.length
            ul className: 'songs', visibleSongs.map (song) ->
              li key: song.id,
                a href: routes.mySong.url(song),
                  "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          else
            div {},
              p {}, MySongs.MSG_NO_SONGS
              p {},
                a
                  href: routes.newSong.url()
                , MySongs.MSG_ADD
                MySongs.MSG_OR
                a
                  href: routes.songs.url()
                , MySongs.MSG_SEARCH
                MySongs.MSG_ONE
          nav {},
            if songs.length > 0
              a
                className: 'btn btn-link'
                href: routes.newSong.url()
              , MySongs.MSG_ADD_NEW_SONG
            if deletedSongs.length > 0
              a
                className: 'btn btn-link'
                href: routes.trash.url()
              , "Trash (#{deletedSongs.length})"

  @MSG_ADD: goog.getMsg 'Add'
  @MSG_ADD_NEW_SONG: goog.getMsg 'Add Song'
  @MSG_NO_SONGS: goog.getMsg "You have no song stored on your device yet."
  @MSG_ONE: goog.getMsg ' one.'
  @MSG_OR: goog.getMsg ' or '
  @MSG_SEARCH: goog.getMsg 'search'
