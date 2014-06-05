goog.provide 'app.home.react.Page'

class app.home.react.Page

  ###*
    @param {app.Routes} routes
    @constructor
  ###
  constructor: (routes) ->
    {div,h1,a} = React.DOM

    @create = React.createClass

      render: ->
        div className: 'home',
          a href: routes.newSong.createUrl(), Page.MSG_FOO

  ###*
    @desc app.home.react.Page
  ###
  @MSG_FOO: goog.getMsg 'create new song'