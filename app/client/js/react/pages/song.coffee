goog.provide 'app.react.pages.Song'

goog.require 'app.songs.Song'

class app.react.pages.Song

  ###*
    @param {app.songs.Store} store
    @param {app.react.pages.NotFound} notFound
    @constructor
  ###
  constructor: (store, notFound) ->
    {div,h1,h2} = React.DOM

    @create = React.createClass

      render: ->
        return notFound.create null if !store.song

        div className: 'song',
          h1 null, store.song.name
          h2 null, store.song.artist
          div null, store.song.lyrics