goog.provide 'app.react.Layout'

class app.react.Layout

  ###*
    PATTERN(steida): Here we can choose mobile/tablet/desktop layout.
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @constructor
  ###
  constructor: (routes, header, footer) ->

    {div} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'layout',
          header.create()
          @props.page.create()
          footer.create()