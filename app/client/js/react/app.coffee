goog.provide 'app.react.App'

class app.react.App

  ###*
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.react.pages.Home} homePage
    @param {app.react.pages.EditSong} editSong
    @param {app.react.pages.Song} song
    @constructor
  ###
  constructor: (routes, header, footer,
      homePage, editSong, song) ->
    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'app',
          header.create null
          switch routes.getActive()
            when routes.home then homePage.create null
            when routes.newSong then editSong.create null
            when routes.song then song.create null
          footer.create null