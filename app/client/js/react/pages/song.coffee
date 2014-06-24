goog.provide 'app.react.pages.Song'

goog.require 'app.songs.Song'

class app.react.pages.Song

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} store
    @constructor
  ###
  constructor: (routes, store) ->

    song = new app.songs.Song

    @create = React.createClass

      render: ->
        {div,h1} = React.DOM

        div className: 'song',
          h1 null, 'Ahoj'