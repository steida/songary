goog.provide 'app.react.pages.NotFound'

class app.react.pages.NotFound

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, touch) ->
    {div,h1,p} = React.DOM
    {a} = touch.none 'a'

    @component = React.createClass

      render: ->
        div className: 'page',
          # TODO: Localize.
          h1 {}, "This page isn't available"
          p {}, 'The link may be broken, or the page may have been removed.'
          a href: routes.home.url(), 'Continue here please.'
