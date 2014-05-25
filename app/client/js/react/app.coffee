goog.provide 'app.react.App'

class app.react.App

  ###*
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.home.react.Page} homePage
    @param {app.songs.react.EditPage} songsEditPage
    @constructor
  ###
  constructor: (routes, header, footer, homePage, songsEditPage) ->
    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'container',
          header.create null
          switch routes.getActive()
            when routes.home then homePage.create null
            when routes.newSong then songsEditPage.create null
          footer.create null

      componentDidMount: ->
        routes.listen app.Routes.EventType.CHANGE, @onRoutesChange

      onRoutesChange: ->
        @forceUpdate()