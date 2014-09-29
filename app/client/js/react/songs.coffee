goog.provide 'app.react.Songs'

class app.react.Songs

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, touch) ->
    {ul,li} = React.DOM
    {a} = touch.scroll 'a'

    @component = React.createClass
      render: ->
        ul {}, @props.songs.map (song) ->
          li key: song.id,
            a
              href: routes.song.url song
            , "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
