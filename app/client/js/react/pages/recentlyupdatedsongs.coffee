goog.provide 'app.react.pages.RecentlyUpdatedSongs'

class app.react.pages.RecentlyUpdatedSongs

  ###*
    @param {app.react.Songs} songs
    @param {app.songs.Store} songsStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (songs, songsStore, element) ->
    {div, p} = element

    @component = React.createFactory React.createClass

      render: ->
        div className: 'page',
          p {}, RecentlyUpdatedSongs.MSG_RECENTLY_UPDATED_SONGS
          songs.component songs: songsStore.recentlyUpdatedSongs

  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs:'
