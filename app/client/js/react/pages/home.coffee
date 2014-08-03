goog.provide 'app.react.pages.Home'

class app.react.pages.Home

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} songsStore
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, songsStore, touch) ->
    {div,h1,ul,li,br} = React.DOM
    {a} = touch.scroll 'a'

    @create = React.createClass

      render: ->
        div className: 'home',
          h1 null, Home.MSG_MY_SONGS,
          ul null, songsStore.all().map (song) ->
            li key: song.id,
              a href: routes.mySong.createUrl(song),
                "#{song.name} [#{song.artist}]"
          a
            className: 'btn btn-default'
            href: routes.myNewSong.createUrl()
          , Home.MSG_ADD_NEW_SONG
          # a
          #   className: 'btn btn-default'
          #   href: routes.myNewSong.createUrl()
          # , Home.MSG_SONGS

  @MSG_ADD_NEW_SONG: goog.getMsg 'add new song'
  @MSG_MY_SONGS: goog.getMsg 'my songs'
  @MSG_SONGS: goog.getMsg 'songs'
  @MSG_RESET: goog.getMsg 'reset'