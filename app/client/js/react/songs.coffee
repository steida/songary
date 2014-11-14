goog.provide 'app.react.Songs'

class app.react.Songs

  ###*
    @param {app.Routes} routes
    @param {este.react.Element} element
    @constructor
  ###
  constructor: (routes, element) ->
    {ul, li, a} = element

    @component = React.createFactory React.createClass
      render: ->
        ul {}, @props.songs.map (song) ->
          text = "#{song.getDisplayName()} [#{song.getDisplayArtist()}]"
          li key: text,
            a
              href: routes.song.url song
              touchAction: 'scroll'
            , text
