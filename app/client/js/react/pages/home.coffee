goog.provide 'app.react.pages.Home'

class app.react.pages.Home

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} songsStore
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, songsStore, touch) ->
    {div,ul,li} = React.DOM
    {a} = touch.scroll 'a'

    @create = React.createClass

      render: ->
        div className: 'home',
          ul null, songsStore.all().map (song, i) ->
            li key: i,
              a href: routes.mySong.createUrl(song),
                "#{song.name} [#{song.artist}]"
          a
            className: 'btn btn-default'
            href: routes.myNewSong.createUrl()
          , Home.MSG_ADD_NEW_SONG

  @MSG_ADD_NEW_SONG: goog.getMsg 'add new song'