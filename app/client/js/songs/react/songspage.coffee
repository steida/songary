goog.provide 'app.songs.react.SongsPage'

class app.songs.react.SongsPage

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} songsStore
    @param {app.songs.react.SearchSong} searchSong
    @param {app.songs.react.Songs} songs
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, songsStore, searchSong, songs, element) ->
    {div, p, Link} = element

    @component = React.createFactory React.createClass

      render: ->
        div className: 'page',
          searchSong.component()
          songs.component songs: songsStore.foundSongs
          p {},
            Link route: routes.recentlyUpdatedSongs,
              SongsPage.MSG_RECENTLY_UPDATED_SONGS

  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs'
