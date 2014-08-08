goog.provide 'app.react.Layout'

class app.react.Layout

  ###*
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @param {app.react.pages.Song} songPage
    @constructor
  ###
  constructor: (routes, header, footer, songPage) ->

    {div} = React.DOM

    @create = React.createClass

      render: ->
        page = @props.page
        songPageIsShown = page == songPage

        div className: 'layout',
          header.create() unless songPageIsShown
          page.create()
          footer.create() unless songPageIsShown