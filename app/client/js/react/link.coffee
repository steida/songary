goog.provide 'app.react.Link'

class app.react.Link

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (@routes, @touch) ->

  ###*
    @param {este.Route} route
    @param {string} text
    @param {Object=} params
  ###
  to: (route, text, params) ->
    {a} = @touch.none 'a'

    a
      className: if @routes.active == route then 'active' else null
      href: route.url params
    , text
