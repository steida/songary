goog.provide 'app.react.Songs'

class app.react.Songs

  ###*
    @param {app.Routes} routes
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, element) ->
    {ul, li, Link} = element

    @component = React.createFactory React.createClass

      render: ->
        ul {}, @props.songs.map (song) ->
          text = "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          li key: text,
            Link
              route: routes.song
              params: song
              touchAction: 'scroll'
            , text
