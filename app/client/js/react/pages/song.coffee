goog.provide 'app.react.pages.Song'

goog.require 'app.songs.Song'
goog.require 'goog.string'

class app.react.pages.Song

  ###*
    @param {app.songs.Store} store
    @param {app.react.pages.NotFound} notFound
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (store, notFound, routes) ->
    {div,h1,h2,a} = React.DOM

    @create = React.createClass

      render: ->
        return notFound.create null if !store.song

        div className: 'song',
          h1 null, "#{store.song.name} [#{store.song.artist}]"
          div
            className: 'lyrics'
            dangerouslySetInnerHTML: '__html': @getDangerousLyricsHtml()
          a href: routes.editMySong.createUrl(store.song),
            Song.MSG_EDIT_SONG

      getDangerousLyricsHtml: ->
        goog.string
          # Not dangerous html anymore, we escaped.
          .htmlEscape store.song.lyrics
          .replace /\[([^\]]+)\]/g, (str, chord) ->
            "<sup>#{chord}</sup>"

  @MSG_EDIT_SONG: goog.getMsg 'Edit song'