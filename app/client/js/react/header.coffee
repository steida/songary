goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.react.TouchAnchor} touchAnchor
    @constructor
  ###
  constructor: (routes, touchAnchor) ->
    {h1} = React.DOM

    @create = React.createClass

      render: ->
        h1 null,
          touchAnchor.create href: routes.home.createUrl(), 'Songary'