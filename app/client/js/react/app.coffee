goog.provide 'app.react.App'

class app.react.App

  ###*
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.react.pages.Home} home
    @param {app.react.pages.EditSong} editSong
    @param {app.react.pages.Song} song
    @param {app.react.pages.NotFound} notFound
    @constructor
  ###
  constructor: (routes,
      header, footer,
      home, editSong, song, notFound) ->

    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'app',
          header.create()
          switch routes.active
            when routes.home then home.create()
            when routes.newSong, routes.editMySong then editSong.create()
            when routes.mySong then song.create()
            when routes.notFound then notFound.create()
          footer.create()