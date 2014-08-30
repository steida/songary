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
        div className: 'page',
          h1 {}, Home.MSG_MY_SONGS
          ul {}, userStore.songsSortedByName().map (song) ->
            li key: song.id,
              a href: routes.mySong.url(song),
                "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          a
            className: 'btn btn-default'
            href: routes.myNewSong.url()
          , Home.MSG_ADD_NEW_SONG

  @MSG_ADD_NEW_SONG: goog.getMsg 'add new song'
  @MSG_MY_SONGS: goog.getMsg 'my songs'
  @MSG_SONGS: goog.getMsg 'songs'
  @MSG_RESET: goog.getMsg 'reset'
