goog.provide 'app.react.pages.Songs'

class app.react.pages.Songs

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (routes, touch, songsStore) ->
    {div,p,ul,li} = React.DOM
    {a} = touch.none 'a'

    @component = React.createClass

      render: ->
        lastTenSongs = songsStore.lastTenSongs.map (song) ->
          li key: song.id,
            a
              href: routes.song.url song
            , "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"

        div className: 'page',
          p {}, Songs.MSG_LAST_TEN_SONGS
          ul {}, lastTenSongs

  @MSG_LAST_TEN_SONGS: goog.getMsg 'Last ten added songs:'
