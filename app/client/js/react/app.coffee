goog.provide 'app.react.App'

class app.react.App

  ###*
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.react.pages.Home} homePage
    @param {app.react.pages.EditSong} editSong
    @constructor
  ###
  constructor: (routes, header, footer,
      homePage, editSong) ->
    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'app',
          header.create null
          switch routes.getActive()
            when routes.home then homePage.create null
            when routes.newSong then editSong.create null
            # when routes.song then songPage.create null
          footer.create null