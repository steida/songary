goog.provide 'app.home.react.Page'

class app.home.react.Page

  ###*
    TODO: Rename to homepage, this is confusing.
    @param {app.Routes} routes
    @param {app.users.Store} usersStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, usersStore, element) ->
    {div, ul, li, p, nav, Link} = element

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
                Link
                  route: routes.mySong
                  params: song
                  touchAction: 'pan-y'
                , "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          else
            div {},
              p {}, Page.MSG_NO_SONGS
              p {},
                Link route: routes.newSong, Page.MSG_ADD
                Page.MSG_OR
                Link route: routes.songs, Page.MSG_SEARCH
                Page.MSG_ONE
          nav {},
            if songs.length > 0
              Link
                className: 'btn btn-link'
                route: routes.newSong
              , Page.MSG_ADD_NEW_SONG
            if deletedSongs.length > 0
              Link
                className: 'btn btn-link'
                route: routes.trash
              , "Trash (#{deletedSongs.length})"

  @MSG_ADD: goog.getMsg 'Add'
  @MSG_ADD_NEW_SONG: goog.getMsg 'Add Song'
  @MSG_NO_SONGS: goog.getMsg "You have no song stored on your device yet."
  @MSG_ONE: goog.getMsg ' one.'
  @MSG_OR: goog.getMsg ' or '
  @MSG_SEARCH: goog.getMsg 'search'
