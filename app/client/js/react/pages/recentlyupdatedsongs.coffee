goog.provide 'app.react.pages.RecentlyUpdatedSongs'

class app.react.pages.RecentlyUpdatedSongs

  ###*
    @param {app.react.Songs} songs
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (songs, songsStore) ->
    {div, p} = React.DOM

    @component = React.createFactory React.createClass

      render: ->
        div className: 'page',
          p {}, RecentlyUpdatedSongs.MSG_RECENTLY_UPDATED_SONGS
          songs.component songs: songsStore.recentlyUpdatedSongs

  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs:'
