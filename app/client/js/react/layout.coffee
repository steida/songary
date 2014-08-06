goog.provide 'app.react.Layout'

class app.react.Layout

  ###*
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.react.pages.Song} song
    @constructor
  ###
  constructor: (routes, header, footer, song) ->

    {div} = React.DOM

    @create = React.createClass

      render: ->
        page = @props.page
        return null if !page
        songPageIsShown = page == song

        div className: 'layout',
          header.create() unless songPageIsShown
          page.create()
          footer.create() unless songPageIsShown