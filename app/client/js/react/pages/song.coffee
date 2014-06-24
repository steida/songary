goog.provide 'app.react.pages.Song'

goog.require 'app.songs.Song'

class app.react.pages.Song

  ###*
    @param {app.Routes} routes
    @param {app.songs.Store} store
    @param {app.react.pages.NotFound} notFound
    @constructor
  ###
  constructor: (routes, store, notFound) ->
    {div,h1,h2} = React.DOM

    @create = React.createClass

      render: ->
        song = store.songByUrl routes.active.params
        return notFound.create null if !song

        div className: 'song',
          h1 null, song.name
          h2 null, song.artist
          div null, song.lyrics