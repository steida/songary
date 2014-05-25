goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    {h1,a} = React.DOM

    @create = React.createClass

      render: ->
        h1 null,
          a href: routes.home.createUrl(), 'Songary'