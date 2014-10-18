goog.provide 'app.react.Link'

goog.require 'goog.asserts'

class app.react.Link

  ###*
    TODO: Move to este-library once api is stabilized.
    @param {app.Routes} routes
    @param {app.react.Gesture} gesture
    @constructor
  ###
  constructor: (@routes, @gesture) ->

  ###*
    @typedef {{
      route: este.Route,
      text: string,
      params: (Object|undefined),
      props: (Object|undefined),
      activeFor: (Array.<este.Route>|undefined)
    }}
  ###
  @Options: null

  ###*
    @param {(este.Route|app.react.Link.Options)} routeOrOptions
    @param {string=} text
    @param {Object=} params Url params.
    @param {Object=} props React props.
    @param {Array.<este.Route>=} activeFor Additional active routes.
  ###
  to: (routeOrOptions, text, params, props, activeFor) ->
    if arguments.length == 1
      goog.asserts.assertObject routeOrOptions
      {route, text, params, props, activeFor} = routeOrOptions
    else
      route = routeOrOptions
      goog.asserts.assertInstanceof route, este.Route
      goog.asserts.assertString text

    activeFor ?= []
    activeFor.push route

    linkProps = href: route.url params
    goog.mixin linkProps, props || {}

    classNames = (linkProps.className || '').match(/\S+/g) || []
    if activeFor.indexOf(@routes.active) != -1
      classNames.push 'active'
    linkProps.className = classNames.join ' '

    # "Fast click" anchor.
    {a} = @gesture.none 'a'
    a linkProps, text
