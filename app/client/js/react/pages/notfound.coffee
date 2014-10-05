goog.provide 'app.react.pages.NotFound'

class app.react.pages.NotFound

  ###*
    @param {app.Routes} routes
    @param {app.react.Gesture} gesture
    @constructor
  ###
  constructor: (routes, gesture) ->
    {div,h1,p} = React.DOM
    {a} = gesture.none 'a'

    @component = React.createClass

      render: ->
        div className: 'page',
          # TODO: Localize.
          h1 {}, "This page isn't available"
          p {}, 'The link may be broken, or the page may have been removed.'
          a href: routes.home.url(), 'Continue here please.'
