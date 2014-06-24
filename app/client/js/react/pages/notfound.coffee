goog.provide 'app.react.pages.NotFound'

class app.react.pages.NotFound

  ###*
    @constructor
  ###
  constructor: ->
    {div} = React.DOM

    @create = React.createClass

      render: ->
        div null, 'This page does not exist.'