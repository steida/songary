goog.provide 'app.songs.react.RecentlyUpdatedSongsPage'

class app.songs.react.RecentlyUpdatedSongsPage

  ###*
    @param {app.songs.react.Songs} songs
    @param {app.songs.Store} songsStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (songs, songsStore, element) ->
    {div, p} = element

    @component = React.createFactory React.createClass

      render: ->
        div className: 'page',
          p {}, RecentlyUpdatedSongsPage.MSG_RECENTLY_UPDATED_SONGS
          songs.component songs: songsStore.recentlyUpdatedSongs

  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs:'
