goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, touch) ->
    {h1} = React.DOM
    {a} = touch.none 'a'

    @create = React.createClass
      render: ->
        h1 null,
          a href: routes.home.createUrl(), 'Songary'