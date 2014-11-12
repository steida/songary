goog.provide 'app.react.pages.Songs'

goog.require 'goog.async.Delay'

class app.react.pages.Songs

  ###*
    @param {app.Actions} actions
    @param {app.Routes} routes
    @param {app.react.Link} link
    @param {app.react.Songs} songs
    @param {app.songs.Store} songsStore
    @constructor
  ###
  constructor: (actions, routes, link, songs, songsStore) ->
    {div, input, p} = React.DOM
    query = ''

    @component = React.createFactory React.createClass

      render: ->
        div className: 'page',
          div className: 'form-group',
            input
              autoFocus: goog.labs.userAgent.device.isDesktop()
              className: 'form-control'
              onChange: @onSearchChange
              placeholder: Songs.MSG_SEARCH_FIELD_PLACEHOLDER
              value: query
          songs.component songs: songsStore.foundSongs
          p {},
            link.to routes.recentlyUpdatedSongs, Songs.MSG_RECENTLY_UPDATED_SONGS

      componentDidMount: ->
        @delay = new goog.async.Delay @onDelayAction, 300

      onDelayAction: ->
        actions.searchSong query

      componentWillUnmount: ->
        @delay.dispose()

      onSearchChange: (e) ->
        query = e.target.value.slice 0, Songs.SEARCH_QUERY_MAX_LENGTH
        @forceUpdate()
        @delay.start()

  @SEARCH_QUERY_MAX_LENGTH: 100
  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs.'
  @MSG_SEARCH_FIELD_PLACEHOLDER: goog.getMsg 'Search song by name, artist, or lyrics.'
