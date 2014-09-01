goog.provide 'app.react.pages.MySongs'

class app.react.pages.MySongs

  ###*
    @param {app.Routes} routes
    @param {app.user.Store} userStore
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, userStore, touch) ->
    {div,h1,ul,li} = React.DOM
    {a} = touch.scroll 'a'

    @component = React.createClass

      render: ->
        allSongs = userStore.songsSortedByName()
        songs = allSongs.filter (song) -> !song.inTrash
        deletedSongs = allSongs.filter (song) -> song.inTrash

        div className: 'page',
          ul {}, songs.map (song) ->
            li key: song.id,
              a href: routes.mySong.url(song),
                "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          a
            className: 'btn btn-link'
            href: routes.newSong.url()
          , MySongs.MSG_ADD_NEW_SONG
          deletedSongs.length > 0 && a
            className: 'btn btn-link'
            href: routes.trash.url()
          , "Trash (#{deletedSongs.length})"

  @MSG_ADD_NEW_SONG: goog.getMsg 'Add New Song'
