goog.provide 'app.react.pages.Songs'

class app.react.pages.Songs

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, touch) ->
    {div,p} = React.DOM
    {a} = touch.scroll 'a'

    @component = React.createClass

      render: ->
        div className: 'page',
          p {},
            a href: routes.recentlyUpdatedSongs.url(), Songs.MSG_RECENTLY_UPDATED_SONGS

  @MSG_RECENTLY_UPDATED_SONGS: goog.getMsg 'Recently updated songs.'
