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
    @param {Object=} urlParams
    @param {Object=} props
  ###
  to: (route, text, urlParams, props) ->
    {a} = @touch.none 'a'

    linkProps = href: route.url urlParams
    goog.mixin linkProps, props if props
    linkProps.className ?= ''
    linkProps.className += ' ' + if @routes.active == route then 'active' else ''
    delete linkProps.className if !linkProps.className.trim()

    a linkProps, text
