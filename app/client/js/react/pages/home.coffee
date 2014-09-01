goog.provide 'app.react.pages.Home'

class app.react.pages.Home

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
          h1 {}, Home.MSG_TITLE
          ul {}, songs.map (song) ->
            li key: song.id,
              a href: routes.mySong.url(song),
                "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          a
            className: 'btn btn-link'
            href: routes.newSong.url()
          , Home.MSG_ADD_NEW_SONG
          deletedSongs.length > 0 && a
            className: 'btn btn-link'
            href: routes.trash.url()
          , "Trash (#{deletedSongs.length})"

  @MSG_ADD_NEW_SONG: goog.getMsg 'Add new song'
  @MSG_TITLE: goog.getMsg 'My songs'
