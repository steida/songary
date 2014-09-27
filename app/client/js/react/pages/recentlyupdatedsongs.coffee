goog.provide 'app.react.pages.RecentlyUpdatedSongs'

class app.react.pages.RecentlyUpdatedSongs

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (routes, touch, songsStore) ->
    {div,p,ul,li} = React.DOM
    {a} = touch.scroll 'a'

    @component = React.createClass

      render: ->
        div className: 'page',
          p {}, RecentlyUpdatedSongs.MSG_RECENTLY_UPDATED_SONGS
          ul {}, songsStore.recentlyUpdatedSongs.map (song) ->
            li key: song.id,
              a
                href: routes.song.url song
              , "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"

  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs:'
