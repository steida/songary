goog.provide 'app.react.Header'

class app.react.Header

  ###*
    @param {app.Routes} routes
    @param {app.react.Touch} touch
    @constructor
  ###
  constructor: (routes, touch) ->
    {header,nav,ul} = React.DOM
    {a} = touch.none 'a'

    @component = React.createClass
      render: ->
        header {},
          nav {},
            a href: routes.home.url(), Header.MSG_MY_SONGS

  @MSG_MY_SONGS: goog.getMsg 'My Songs'
