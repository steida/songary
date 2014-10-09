goog.provide 'app.react.Songs'

class app.react.Songs

  ###*
    @param {app.Routes} routes
    @param {app.react.Gesture} gesture
    @constructor
  ###
  constructor: (routes, gesture) ->
    {ul,li} = React.DOM
    {a} = gesture.scroll 'a'

    @component = React.createClass
      render: ->
        ul {}, @props.songs.map (song) ->
          text = "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          li key: text,
            a
              href: routes.song.url song
            , text
