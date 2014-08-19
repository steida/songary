goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, touch) ->
    {header,h1} = React.DOM
    {a} = touch.none 'a'

    @component = React.createClass
      render: ->
        header {},
          h1 {},
            a href: routes.home.url(), 'Songary'
