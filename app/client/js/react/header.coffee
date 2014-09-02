goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, touch) ->
    {header,nav} = React.DOM
    {a} = touch.none 'a'

    linkTo = (route, text) ->
      a
        className: if routes.active == route then 'active' else null
        href: route.url()
      , text

    @component = React.createClass
      render: ->
        header {}, nav {},
          linkTo routes.home, Header.MSG_MY_SONGS
          linkTo routes.about, Header.MSG_ABOUT

  @MSG_MY_SONGS: goog.getMsg 'My Songs'
  @MSG_ABOUT: goog.getMsg 'About'
