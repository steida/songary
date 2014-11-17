goog.provide 'app.react.pages.Songs'

class app.react.pages.Songs

  ###*
    @param {app.Routes} routes
    @param {app.react.SearchSong} searchSong
    @param {app.react.Songs} songs
    @param {app.songs.Store} songsStore
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, searchSong, songs, songsStore, element) ->
    {div, p, Link} = element

    @component = React.createFactory React.createClass

      render: ->
        div className: 'page',
          searchSong.component()
          songs.component songs: songsStore.foundSongs
          p {},
            Link route: routes.recentlyUpdatedSongs,
              Songs.MSG_RECENTLY_UPDATED_SONGS

  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs'
