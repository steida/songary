goog.provide 'app.react.Link'

goog.require 'goog.asserts'

class app.react.Link

  ###*
    TODO: Move to este-library once api is stabilized.
    @param {app.Routes} routes
    @param {este.react.Gesture} gesture
    @constructor
  ###
  constructor: (@routes, @gesture) ->

  ###*
    TODO: Add none, panX, panY, scroll options.
    @typedef {{
      route: este.Route,
      params: (Object|undefined),
      props: (Object|undefined),
      activeFor: (Array<este.Route>|undefined)
    }}
  ###
  @Options: null

  ###*
    @param {app.react.Link.Options} options
    @param {...*} var_args Link content.
  ###
  to: (options, var_args) ->
    goog.asserts.assertObject options
    {route, params, props, activeFor} = options
    goog.asserts.assertInstanceof route, este.Route

    # Ensure activeFor exists, then add route.
    activeFor ?= []
    activeFor.push route

    # Create link props.
    linkProps = href: route.url params
    goog.mixin linkProps, props || {}

    # Set link props className.
    classNames = (linkProps.className || '').match(/\S+/g) || []
    if activeFor.indexOf(@routes.active) != -1
      classNames.push 'active'
    if @routes.active != route
      classNames.push 'clickable'
    linkProps.className = classNames.join ' '

    # "Fast click" anchor, TODO: Enable also panX, panY, scroll.
    {a} = @gesture.none 'a'
    # Pass props as first arg then all content args.
    a.apply null, [linkProps].concat Array.prototype.slice.call arguments, 1
