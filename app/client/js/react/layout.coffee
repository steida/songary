goog.provide 'app.react.Layout'

class app.react.Layout

  ###*
    @param {app.Routes} routes
    @param {app.react.Header} header
    @param {app.react.Footer} footer
    @constructor
  ###
  constructor: (routes, header, footer) ->

    {div} = React.DOM

    @component = React.createClass

      render: ->
        div className: 'layout',
          header.component() unless @props.isSongPage
          @props.component
          footer.component() unless @props.isSongPage
